return {
	{
		-- Completion
		'hrsh7th/nvim-cmp',
		event = { 'InsertEnter', 'CmdlineEnter' },
		dependencies = {
			'hrsh7th/cmp-nvim-lsp',
			'hrsh7th/cmp-buffer',
			'hrsh7th/cmp-path',
			'hrsh7th/cmp-cmdline',
			'uga-rosa/cmp-dictionary',
			'lukas-reineke/cmp-under-comparator',
			'onsails/lspkind.nvim',
			'L3MON4D3/LuaSnip',
			'saadparwaiz1/cmp_luasnip',
			'Saecki/crates.nvim'
		},
		config = function()
			local cmp = require("cmp")
			local types = require("cmp.types")
			local comparator = require("cmp-under-comparator")

			-- for rust crate
			require("crates").setup({
				lsp = {
					enabled = true,
					on_attach = function(client, bufnr)
						-- the same on_attach function as for your other lsp's
					end,
					actions = true,
					completion = true,
					hover = true,
				},
			})

			-- Global setup
			cmp.setup({
				completion = {
					autocomplete = {
						cmp.TriggerEvent.InsertEnter,
						cmp.TriggerEvent.TextChanged
					}
				},
				preselect = cmp.PreselectMode.None,
				formatting = {
					-- fields = {'abbr', 'kind', 'menu'},
					format = require("lspkind").cmp_format({
						mode = "symbol_text",
						menu = {
							buffer = "[Buffer]",
							nvim_lsp = "[LSP]",
							copilot = "[Copilot]",
							luasnip = "[LuaSnip]",
							nvim_lua = "[NeovimLua]",
							path = "[Path]",
							omni = "[Omni]",
							spell = "[Spell]",
							emoji = "[Emoji]",
							calc = "[Calc]",
							rg = "[Rg]",
							treesitter = "[TS]",
							mocword = "[mocword]",
							cmdline_history = "[History]",
						},
					}),
				},
				snippet = {
					-- REQUIRED - you must specify a snippet engine
					expand = function(args)
						-- vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
						require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
						-- require('snippy').expand_snippet(args.body) -- For `snippy` users.
						-- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
					end,
				},
				window = {
					-- completion = cmp.config.window.bordered(),
					-- documentation = cmp.config.window.bordered(),
				},
				sorting = {
					comparators = {
						cmp.config.compare.offset,
						cmp.config.compare.exact,
						cmp.config.compare.score,
						comparator.under,
						function(entry1, entry2)
							local kind1 = entry1:get_kind()
							kind1 = kind1 == types.lsp.CompletionItemKind.Text and 100 or kind1
							local kind2 = entry2:get_kind()
							kind2 = kind2 == types.lsp.CompletionItemKind.Text and 100 or kind2
							if kind1 ~= kind2 then
								if kind1 == types.lsp.CompletionItemKind.Snippet then
									return false
								end
								if kind2 == types.lsp.CompletionItemKind.Snippet then
									return true
								end
								local diff = kind1 - kind2
								if diff < 0 then
									return true
								elseif diff > 0 then
									return false
								end
							end
						end,
						cmp.config.compare.sort_text,
						cmp.config.compare.length,
						cmp.config.compare.order,
					},
				},
				sources = cmp.config.sources({
					{ name = 'luasnip',  max_item_count = 10, priority = 100 },
					{ name = 'nvim_lsp', max_item_count = 20, priority = 90 },
				}, {
					{ name = 'path', max_item_count = 5, priority = 70 },
				}, {
					{
						name = 'buffer',
						max_item_count = 5,
						priority = 80,
						option = {
							get_bufnrs = function()
								local bufs = {}
								for _, win in ipairs(vim.api.nvim_list_wins()) do
									bufs[vim.api.nvim_win_get_buf(win)] = true
								end
								return vim.tbl_keys(bufs)
							end
						}
					},
					{ name = 'dictionary', priority = 10, keyword_length = 3 },
					{ name = 'crates',     priority = 10 }, -- for rust crate
				}),
				mapping = cmp.mapping.preset.insert({
					['<C-d>'] = cmp.mapping.scroll_docs(-4),
					['<C-f>'] = cmp.mapping.scroll_docs(4),
					['<C-p>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
					['<C-n>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
					['<C-y>'] = cmp.mapping.confirm({ select = true }),
					['<C-k>'] = cmp.mapping.confirm({ select = true }),
				}),
			})
			require("cmp_dictionary").setup({
				paths = { vim.fn.stdpath("config") .. "/words" },
				exact_length = 3,
			})

			-- Set configuration for specific filetype.
			cmp.setup.filetype('gitcommit', {
				sources = cmp.config.sources({
					{ name = 'cmp_git' }, -- You can specify the `cmp_git` source if you were installed it.
				}, {
					{ name = 'buffer' },
				})
			})

			-- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
			cmp.setup.cmdline('/', {
				mapping = cmp.mapping.preset.cmdline(),
				sources = {
					{ name = 'buffer', max_item_count = 10 }
				}
			})

			-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
			cmp.setup.cmdline(':', {
				mapping = cmp.mapping.preset.cmdline(),
				sources = cmp.config.sources({
					{ name = 'path', max_item_count = 10 }
				}, {
					{ name = 'cmdline', max_item_count = 10 }
				})
			})
		end
	},
	{
		'neovim/nvim-lspconfig',
		event = { 'BufReadPre', 'BufNewFile' },
		dependencies = {
			-- LSP manage
			{
				'williamboman/mason.nvim',
				build = function()
					pcall(vim.cmd, 'MasonUpdate')
				end,
				config = function()
					require("mason").setup()
				end
			},
			{
				'williamboman/mason-lspconfig.nvim',
				config = function()
					require("mason-lspconfig").setup({
						automatic_enable = true,
						ensure_installed = { "lua_ls", "rust_analyzer", "gopls", "pyright" }
					})
				end
			},
			-- Completion
			{ 'hrsh7th/cmp-nvim-lsp' },
			{ 'hrsh7th/nvim-cmp' },
			-- Snippets
			{ 'L3MON4D3/LuaSnip' },
		},
		keys = {
			{
				'K',
				function()
					if next(vim.lsp.get_clients({ bufnr = 0 })) then vim.lsp.buf.hover() end
				end,
				mode = 'n',
				desc = 'LSP Hover'
			},
			{
				'L',
				function()
					if next(vim.lsp.get_clients({ bufnr = 0 })) then vim.diagnostic.open_float() end
				end,
				mode = 'n',
				desc = 'Diagnostics Float'
			},
			{
				'F',
				function()
					if next(vim.lsp.get_clients({ bufnr = 0 })) then vim.lsp.buf.format() end
				end,
				mode = 'n',
				desc = 'LSP Format'
			},
			{
				'gd',
				function()
					if next(vim.lsp.get_clients({ bufnr = 0 })) then vim.lsp.buf.definition() end
				end,
				mode = 'n',
				desc = 'Goto Definition'
			},
			{
				'gD',
				function()
					if next(vim.lsp.get_clients({ bufnr = 0 })) then vim.lsp.buf.declaration() end
				end,
				mode = 'n',
				desc = 'Goto Declaration'
			},
			{
				'gr',
				function()
					if next(vim.lsp.get_clients({ bufnr = 0 })) then vim.lsp.buf.references() end
				end,
				mode = 'n',
				desc = 'References'
			},
			{
				'gi',
				function()
					if next(vim.lsp.get_clients({ bufnr = 0 })) then vim.lsp.buf.implementation() end
				end,
				mode = 'n',
				desc = 'Goto Implementation'
			},
			{
				'gs',
				function()
					if next(vim.lsp.get_clients({ bufnr = 0 })) then vim.lsp.buf.signature_help() end
				end,
				mode = 'n',
				desc = 'Signature Help'
			},
			{
				'<space>rn',
				function()
					if next(vim.lsp.get_clients({ bufnr = 0 })) then vim.lsp.buf.rename() end
				end,
				mode = 'n',
				desc = 'LSP Rename'
			},
			{
				'<space>ca',
				function()
					if next(vim.lsp.get_clients({ bufnr = 0 })) then vim.lsp.buf.code_action() end
				end,
				mode = { 'n', 'v' },
				desc = 'LSP Code Action'
			},
		},
		config = function()
			local capabilities = require('cmp_nvim_lsp').default_capabilities()
			local on_attach = function(_, _) end

			vim.lsp.config('*', { on_attach = on_attach, capabilities = capabilities })

			-- server settings
			vim.lsp.config('lua_ls', {
				settings = {
					Lua = {
						diagnostics = { globals = { 'vim' } },
						completion = { callSnippet = 'Replace' },
					},
				},
			})
			vim.lsp.config("gopls", {
				settings = {
					["gopls"] = {
						usePlaceholders = true,
						analyses = {
							usedparams = true
						}
					},
				},
			})
			vim.lsp.config("rust_analyzer", {
				settings = {
					["rust-analyzer"] = {
						imports = {
							granularity = {
								group = "module",
							},
							prefix = "self",
						},
						cargo = {
							buildScripts = {
								enable = true,
							},
						},
						procMacro = {
							enable = true
						},
					},
				},
			})
		end
	},
	{
		"pmizio/typescript-tools.nvim",
		dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
		ft = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
		keys = {
			{ "<space>rF", ":TSToolsRenameFile sync<CR>", mode = "n", desc = "TS Rename File" },
		},
		opts = {
			tsserver_file_preferences = {
				includeInlayParameterNameHints = "all",
				includeInlayParameterNameHintsWhenArgumentMatchesName = true,
				includeInlayFunctionParameterTypeHints = true,
				includeInlayVariableTypeHints = true,
				includeInlayVariableTypeHintsWhenTypeMatchesName = true,
				includeInlayPropertyDeclarationTypeHints = true,
				includeInlayFunctionLikeReturnTypeHints = true,
			},
		},
		config = function()
			require("typescript-tools").setup {
				on_attach = function(_, _) end,
				handlers = {},
				settings = {
					separate_diagnostic_server = true,
					publish_diagnostic_on = "insert_leave",
					expose_as_code_action = {},
					tsserver_path = nil,
					tsserver_plugins = {},
					tsserver_max_memory = "auto",
					tsserver_format_options = {},
					tsserver_file_preferences = {},
					tsserver_locale = "en",
					complete_function_calls = true,
					include_completions_with_insert_text = true,
					code_lens = "off",
					disable_member_code_lens = true,
					jsx_close_tag = {
						enable = true,
						filetypes = { "javascriptreact", "typescriptreact" },
					},
				},
			}
		end
	},
	{
		'L3MON4D3/LuaSnip',
		keys = {
			{
				'<C-k>',
				function()
					local ok, ls = pcall(require, 'luasnip')
					if ok and ls.expand_or_jumpable() then ls.expand_or_jump() end
				end,
				mode = 'i',
				desc = 'LuaSnip Expand/Jump'
			},
		},
	},
	{
		"antosha417/nvim-lsp-file-operations",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-tree.lua",
		},
		event = { 'VeryLazy' },
		config = function()
			require("lsp-file-operations").setup()
		end,
	},
	{
		'ray-x/lsp_signature.nvim',
		event = { 'LspAttach' },
		config = function()
			local cfg = {
				debug = false,                                          -- set to true to enable debug logging
				log_path = vim.fn.stdpath("cache") .. "/lsp_signature.log", -- log dir when debug is on
				-- default is  ~/.cache/nvim/lsp_signature.log
				verbose = false,                                        -- show debug line number
				bind = true,                                            -- This is mandatory, otherwise border config won't get registered.
				-- If you want to hook lspsaga or other signature handler, pls set to false
				doc_lines = 10,                                         -- will show two lines of comment/doc(if there are more than two lines in doc, will be truncated);
				-- set to 0 if you DO NOT want any API comments be shown
				-- This setting only take effect in insert mode, it does not affect signature help in normal
				-- mode, 10 by default

				max_height = 12,                   -- max height of signature floating_window
				max_width = 80,                    -- max_width of signature floating_window
				wrap = true,                       -- allow doc/signature text wrap inside floating_window, useful if your lsp return doc/sig is too long
				floating_window = true,            -- show hint in a floating window, set to false for virtual text only mode
				floating_window_above_cur_line = true, -- try to place the floating above the current line when possible Note:
				-- will set to true when fully tested, set to false will use whichever side has more space
				-- this setting will be helpful if you do not want the PUM and floating win overlap

				floating_window_off_x = 1, -- adjust float windows x position.
				floating_window_off_y = 0, -- adjust float windows y position. e.g -2 move window up 2 lines; 2 move down 2 lines
				close_timeout = 4000, -- close floating window after ms when laster parameter is entered
				fix_pos = false, -- set to true, the floating window will not auto-close until finish all parameters
				hint_enable = true, -- virtual hint enable
				hint_prefix = "▸ ", -- Panda for parameter, NOTE: for the terminal not support emoji, might crash
				hint_scheme = "String",
				hi_parameter = "LspSignatureActiveParameter", -- how your parameter will be highlight
				handler_opts = {
					border = "rounded" -- double, rounded, single, shadow, none
				},
				always_trigger = false, -- sometime show signature on new line or in middle of parameter can be confusing, set it to false for #58
				auto_close_after = nil, -- autoclose signature float win after x sec, disabled if nil.
				extra_trigger_chars = {}, -- Array of extra characters that will trigger signature completion, e.g., {"(", ","}
				zindex = 200, -- by default it will be on top of all floating windows, set to <= 50 send it to bottom
				padding = '', -- character to pad on left and right of signature can be ' ', or '|'  etc
				transparency = nil, -- disabled by default, allow floating win transparent value 1~100
				shadow_blend = 36, -- if you using shadow as border use this set the opacity
				shadow_guibg = 'Black', -- if you using shadow as border use this set the color e.g. 'Green' or '#121315'
				timer_interval = 200, -- default timer check interval set to lower value if you want to reduce latency
				toggle_key = nil, -- toggle signature on and off in insert mode,  e.g. toggle_key = '<M-x>'
				select_signature_key = nil, -- cycle to next signature, e.g. '<M-n>' function overloading
				move_cursor_key = nil, -- imap, use nvim_set_current_win to move cursor between current win and floating
			}

			-- recommended:
			require 'lsp_signature'.setup(cfg) -- no need to specify bufnr if you don't use toggle_key

			-- You can also do this inside lsp on_attach
			-- note: on_attach deprecated
		end
	},
}
