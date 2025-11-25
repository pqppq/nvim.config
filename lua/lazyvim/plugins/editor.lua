return {
	"mg979/vim-visual-multi", -- multi cursor selection with Ctrl-n
	"kevinhwang91/nvim-bqf", -- Quicfix preview
	{
		'monaqa/dial.nvim',
		keys = {
			{ "<C-a>", mode = { "n" }, "<Plug>(dial-increment)" },
			{ "<C-x>", mode = { "n" }, "<Plug>(dial-decrement)" },
		},
		config = function()
			local augend = require("dial.augend")
			require("dial.config").augends:register_group {
				default = {
					augend.integer.alias.decimal,
					augend.integer.alias.hex,
					augend.date.alias["%Y/%m/%d"],
					augend.constant.alias.bool,
				},
			}
		end
	},
	{
		"folke/zen-mode.nvim",
		config = function()
			vim.keymap.set("n", '<Space>zz', function()
				require("zen-mode").setup {
					window = {
						width = 90,
						options = {}
					},
				}
				require("zen-mode").toggle()
			end
			)
		end
	},
	{
		"ThePrimeagen/refactoring.nvim",
		requires = {
			{ "nvim-lua/plenary.nvim" },
			{ "nvim-treesitter/nvim-treesitter" }
		},
		config = function()
			vim.keymap.set({ 'x', 'n' }, '<space>dv', function()
				require('refactoring').debug.print_var()
			end)
			vim.keymap.set('n', '<space>dc', function()
				require('refactoring').debug.cleanup {}
			end)
		end
	},
	{
		-- auto close brackets
		'windwp/nvim-autopairs',
		event = "InsertEnter",
		config = true
	},
	{
		-- snippet engine
		'L3MON4D3/LuaSnip',
		-- follow latest release.
		version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
		-- install jsregexp (optional!).
		build = "make install_jsregexp",
		lazy = true,
		config = function()
			local ls = require("luasnip")
			local types = require("luasnip.util.types")

			-- If you're reading this file for the first time, best skip to around line 190
			-- where the actual snippet-definitions start.

			-- Every unspecified option will be set to the default.
			ls.config.set_config({
				history = true,
				-- Update more often, :h events for more info.
				updateevents = "TextChanged,TextChangedI",
				-- Snippets aren't automatically removed if their text is deleted.
				-- `delete_check_events` determines on which events (:h events) a check for
				-- deleted snippets is performed.
				-- This can be especially useful when `history` is enabled.
				delete_check_events = "TextChanged",
				ext_opts = { [types.choiceNode] = { active = { virt_text = { { "choiceNode", "Comment" } } } } },
				-- treesitter-hl has 100, use something higher (default is 200).
				ext_base_prio = 300,
				-- minimal increase in priority.
				ext_prio_increase = 1,
				enable_autosnippets = true,
				-- mapping for cutting selected text so it's usable as SELECT_DEDENT,
				-- SELECT_RAW or TM_SELECTED_TEXT (mapped via xmap).
				-- store_selection_keys = "<Tab>",
				-- luasnip uses this function to get the currently active filetype. This
				-- is the (rather uninteresting) default, but it's possible to use
				-- eg. treesitter for getting the current filetype by setting ft_func to
				-- require("luasnip.extras.filetype_functions").from_cursor (requires
				-- `nvim-treesitter/nvim-treesitter`). This allows correctly resolving
				-- the current filetype in eg. a markdown-code block or `vim.cmd()`.
				ft_func = function()
					return vim.split(vim.bo.filetype, ".", true)
				end,
			})

			-- in a lua file: search lua-, then c-, then all-snippets.
			-- ls.filetype_extend("lua", { "c" })
			-- in a cpp file: search c-snippets, then all-snippets only (no cpp-snippets!!).
			-- ls.filetype_set("cpp", { "c" })

			-- Beside defining your own snippets you can also load snippets from "vscode-like" packages
			-- that expose snippets in json files, for example <https://github.com/rafamadriz/friendly-snippets>.
			-- Mind that this will extend  `ls.snippets` so you need to do it after your own snippets or you
			-- will need to extend the table yourself instead of setting a new one.

			-- require("luasnip.loaders.from_vscode").load() -- Load only python snippets
			-- require("luasnip.loaders.from_vscode").load({include = {"python"}}) -- Load only python snippets

			-- The directories will have to be structured like eg. <https://github.com/rafamadriz/friendly-snippets> (include
			-- a similar `package.json`)
			require("luasnip.loaders.from_vscode").lazy_load()
			require("luasnip.loaders.from_vscode").lazy_load({ paths = { "~/repos/nvim.config/snipets/friendly-snippets/" } })

			-- You can also use snippets in snipmate format, for example <https://github.com/honza/vim-snippets>.
			-- The usage is similar to vscode.

			-- One peculiarity of honza/vim-snippets is that the file with the global snippets is _.snippets, so global snippets
			-- are stored in `ls.snippets._`.
			-- We need to tell luasnip that "_" contains global snippets:
			ls.filetype_extend("all", { "_" })

			-- require("luasnip.loaders.from_snipmate").load({include = {"c"}}) -- Load only python snippets

			-- require("luasnip.loaders.from_snipmate").load({path = {"./my-snippets"}}) -- Load snippets from my-snippets folder
			-- If path is not specified, luasnip will look for the `snippets` directory in rtp (for custom-snippet probably
			-- `~/.config/nvim/snippets`).

			-- require("luasnip.loaders.from_snipmate").lazy_load() -- Lazy loading

			-- vim.api.nvim_set_keymap("i", "<Tab>", "v:lua.tab_complete()", { expr = true })
			-- vim.api.nvim_set_keymap("s", "<Tab>", "v:lua.tab_complete()", { expr = true })
			-- vim.api.nvim_set_keymap("i", "<S-Tab>", "v:lua.s_tab_complete()", { expr = true })
			-- vim.api.nvim_set_keymap("s", "<S-Tab>", "v:lua.s_tab_complete()", { expr = true })
			-- vim.api.nvim_set_keymap("i", "<C-Down>", "<Plug>luasnip-next-choice", {})
			-- vim.api.nvim_set_keymap("s", "<C-Down>", "<Plug>luasnip-next-choice", {})
		end,
	},
	{
		-- telescope
		"nvim-telescope/telescope.nvim",
		dependeicies = { "plenary.nvim" },
		keys = {
			{ "<Space>ff", "<cmd>Telescope find_files hidden=true theme=dropdown<CR>" },
			{ "<Space>fj", "<cmd>Telescope live_grep theme=dropdown<CR>" },
			{ "<Space>b",  "<cmd>Telescope buffers theme=dropdown<CR>" },
			{ "<Space>fs", "<cmd>Telescope current_buffer_fuzzy_find theme=dropdown<CR>" },
			-- refactoring
			{ "<Space>R",  mode = { "v" },                                               "<Esc><cmd>lua require('telescope').extensions.refactoring.refactors()<CR>" },
		},
		config = function()
			require('telescope').setup {
				defaults = {
					file_ignore_patterns = { "node_modules", ".git" },
					vimgrep_arguments = {
						"rg",
						"--color=never",
						"--no-heading",
						"--with-filename",
						"--line-number",
						"--column",
						"--smart-case",
						"--trim"
					},
					mappings = {
						i = {
							-- map actions.which_key to <C-h> (default: <C-/>)
							-- actions.which_key shows the mappings for your picker,
							-- e.g. git_{create, delete, ...}_branch for the git_branches picker
							["<C-h>"] = "which_key",
							["<esc>"] = require('telescope.actions').close,
							["jk"] = require('telescope.actions').close,
						},
					},
					pickers = {
						-- Default configuration for builtin pickers goes here:
						-- picker_name = {
						--   picker_config_key = value,
						--   ...
						-- }
						-- Now the picker_config_key will be applied every time you call this
						-- builtin picker
					},
					extensions = {
						'refactoring'
					},
				},
				prompt = "> ",
				selection_caret = "> ",
				entry_prefix = "  ",
				selection_strategy = "reset",
				sorting_strategy = "ascending",
				layout_strategy = "center",
				layout_config = {
					width = 0.8,
					horizontal = {
						mirror = false,
						prompt_position = "top",
						preview_cutoff = 120,
						preview_width = 0.5,
					},
					vertic = {
						mirror = false,
						prompt_position = "top",
						preview_cut = 120,
						preview_width = 0.5,
					},
				},
				file_sorter = require("telescope.sorters").get_fuzzy_file,
				file_ignore_patterns = { "node_modules/*" },
				generic_sorter = require("telescope.sorters").get_generic_fuzzy_sorter,
				path_display = { "truncate" },
				dynamic_preview_title = true,
				winblend = 0,
				border = {},
				color_devicons = true,
				use_less = true,
				scroll_strategy = "cycle",
				buffer_previewer_maker = require("telescope.previewers").buffer_previewer_maker,
			}
		end
	},
	{
		-- quick teminal
		"akinsho/toggleterm.nvim",
		keys = {
			{ "<Esc>", mode = { "t" },                        "<C-\\><C-n>" },
			{ "<C-t>", mode = { "t" },                        "<Cmd>exe v:count1 . 'ToggleTerm'<CR>" },
			{ "<C-t>", "<Cmd>exe v:count1 . 'ToggleTerm'<CR>" },
		},
		config = function()
			require("toggleterm").setup {
				-- size can be a number or function which is passed the current terminal
				size = function(term)
					if term.direction == "horizontal" then
						return 40
					elseif term.direction == "vertical" then
						return vim.o.columns * 0.4
					end
				end,
				open_mapping = [[<c-\>]],
				-- on_open = fun(t: Terminal), -- function to run when the terminal opens
				-- on_close = fun(t: Terminal), -- function to run when the terminal closes
				-- on_stdout = fun(t: Terminal, job: number, data: string[], name: string) -- callback for processing output on stdout
				-- on_stderr = fun(t: Terminal, job: number, data: string[], name: string) -- callback for processing output on stderr
				-- on_exit = fun(t: Terminal, job: number, exit_code: number, name: string) -- function to run when terminal process exits
				hide_numbers = true,  -- hide the number column in toggleterm buffers
				shade_filetypes = {},
				autochdir = false,    -- when neovim changes it current directory the terminal will change it's own when next it's opened
				shade_terminals = false, -- NOTE: this option takes priority over highlights specified so if you specify Normal highlights you should set this to false
				shading_factor = 1,   -- the degree by which to darken to terminal colour, default: 1 for dark backgrounds, 3 for light
				start_in_insert = true,
				insert_mappings = true, -- whether or not the open mapping applies in insert mode
				terminal_mappings = true, -- whether or not the open mapping applies in the opened terminals
				persist_size = true,
				persist_mode = true,  -- if set to true (default) the previous terminal mode will be remembered
				direction = 'float',  -- 'vertical' | 'horizontal' | 'tab' | 'float',
				close_on_exit = true, -- close the terminal window when the process exits
				-- shell = '/bin/zsh',   -- change the default shell
				auto_scroll = true,   -- automatically scroll to the bottom on terminal output
				-- This field is only relevant if direction is set to 'float'
				float_opts = {
					-- The border key is *almost* the same as 'nvim_open_win'
					-- see :h nvim_open_win for details on borders however
					-- the 'curved' border is a custom border type
					-- not natively supported but implemented in this plugin.
					border = 'single', -- 'single' | 'double' | 'shadow' | 'curved' | ... other options supported by win open
					-- like `size`, width and height can be a number or function which is passed the current terminal
					width = math.floor(vim.o.columns * 0.8),
					height = math.floor(vim.o.columns * 1),
					winblend = 0,
					highlight = { border = "ColorColumn", background = "ColorColumn" },
				},
				winbar = {
					enabled = false,
					-- name_formatter = function(term) --  term: Terminal
					--   return term.name
					-- end
				},
			}
		end,
	},
	{
		-- code outline
		"stevearc/aerial.nvim",
		config = function()
			require("aerial").setup({
				-- optionally use on_attach to set keymaps when aerial has attached to a buffer
				layout = { width = 40 },
				autojump = true,
				on_attach = function(bufnr)
					-- Jump forwards/backwards with '{' and '}'
					vim.keymap.set("n", "{", "<cmd>AerialPrev<CR>", { buffer = bufnr })
					vim.keymap.set("n", "}", "<cmd>AerialNext<CR>", { buffer = bufnr })
				end,
			})
			-- You probably also want to set a keymap to toggle aerial
			vim.keymap.set("n", "<Space>a", "<cmd>AerialToggle!<CR>")
		end
	},
	{
		"michaelb/sniprun",
		branch = "master",

		build = "sh install.sh",
		-- do 'sh install.sh 1' if you want to force compile locally
		-- (instead of fetching a binary from the github release). Requires Rust >= 1.65

		config = function()
			require("sniprun").setup({
				vim.api.nvim_set_keymap('v', '<Space>r', '<Plug>SnipRun<CR>', {}),
				vim.api.nvim_set_keymap('n', '<Space>r', '<Plug>SnipRun<CR>', {}),
				vim.api.nvim_set_keymap('n', '<Space>c', '<Plug>SnipClose<CR>', {}),
				vim.api.nvim_set_keymap('n', '<Space>r', '<Plug>SnipRunOperator<CR>', {}),

				display = { "TempFloatingWindow" },

				selected_interpreters = { "JS_TS_bun" },
				repl_enable = { "JS_TS_bun" }
			})
		end,
	},
	{
		"shellRaining/hlchunk.nvim",
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			require("hlchunk").setup({
				chunk = {
					enable = true
				},
				indent = {
					enable = true
				}
			})
		end
	},
	{
		'kevinhwang91/nvim-ufo',
		dependencies = { 'kevinhwang91/promise-async' },
		config = function()
			-- vim.o.foldcolumn = '1' -- '0' is not bad
			vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
			vim.o.foldlevelstart = 99
			vim.o.foldenable = true

			vim.keymap.set('n', 'zf', function()
				local winid = vim.api.nvim_get_current_win()
				local cursor = vim.api.nvim_win_get_cursor(winid)
				local lnum = cursor[1]

				local foldlevel = vim.fn.foldlevel(lnum)
				if foldlevel > 0 then
					vim.cmd(lnum .. "foldclose")
				end
			end)
			vim.keymap.set('n', 'zF', require('ufo').closeAllFolds)
			vim.keymap.set('n', 'zo', require('ufo').openFoldsExceptKinds)
			vim.keymap.set('n', 'zO', require('ufo').openAllFolds)

			require('ufo').setup({
				provider_selector = function(bufnr, filetype, buftype)
					return { 'treesitter', 'indent' }
				end
			})
		end
	},
	{
		'dnlhc/glance.nvim',
		cmd = 'Glance',
		keys = {
			{ "gld", mode = { "n" }, "<cmd>Glance definitions<CR>" },
			{ "glr", mode = { "n" }, "<cmd>Glance references<CR>" },
			{ "glt", mode = { "n" }, "<cmd>Glance type_definitions<CR>" },
			{ "gli", mode = { "n" }, "<cmd>Glance implementations<CR>" },
		},
		config = function()
			-- Lua configuration
			local glance = require('glance')
			local actions = glance.actions

			glance.setup({
				height = 25, -- Height of the window
				zindex = 45,

				-- When enabled, adds virtual lines behind the preview window to maintain context in the parent window
				-- Requires Neovim >= 0.10.0
				preserve_win_context = true,

				-- Controls whether the preview window is "embedded" within your parent window or floating
				-- above all windows.
				detached = function(winid)
					-- Automatically detach when parent window width < 100 columns
					return vim.api.nvim_win_get_width(winid) < 100
				end,
				-- Or use a fixed setting: detached = true,

				preview_win_opts = { -- Configure preview window options
					cursorline = true,
					number = true,
					wrap = true,
				},

				border = {
					enable = false, -- Show window borders. Only horizontal borders allowed
					top_char = '―',
					bottom_char = '―',
				},

				list = {
					position = 'right', -- Position of the list window 'left'|'right'
					width = 0.33,  -- Width as percentage (0.1 to 0.5)
				},

				theme = {
					enable = true, -- Generate colors based on current colorscheme
					mode = 'auto', -- 'brighten'|'darken'|'auto', 'auto' will set mode based on the brightness of your colorscheme
				},

				mappings = {
					list = {
						['j'] = actions.next, -- Next item
						['k'] = actions.previous, -- Previous item
						['<Down>'] = actions.next,
						['<Up>'] = actions.previous,
						['<Tab>'] = actions.next_location,    -- Next location (skips groups, cycles)
						['<S-Tab>'] = actions.previous_location, -- Previous location (skips groups, cycles)
						['<C-f>'] = actions.preview_scroll_win(5), -- Scroll up the preview window
						['<C-b>'] = actions.preview_scroll_win(-5), -- Scroll down the preview window
						['v'] = actions.jump_vsplit,          -- Open location in vertical split
						['s'] = actions.jump_split,           -- Open location in horizontal split
						['t'] = actions.jump_tab,             -- Open in new tab
						['<CR>'] = actions.jump,              -- Jump to location
						['o'] = actions.jump,
						['l'] = actions.open_fold,
						['h'] = actions.close_fold,
						['<space>l'] = actions.enter_win('preview'), -- Focus preview window
						['q'] = actions.close,                 -- Closes Glance window
						['Q'] = actions.close,
						['<Esc>'] = actions.close,
						['<C-q>'] = actions.quickfix, -- Send all locations to quickfix list
						-- ['<Esc>'] = false -- Disable a mapping
					},

					preview = {
						['Q'] = actions.close,
						['<Tab>'] = actions.next_location,  -- Next location (skips groups, cycles)
						['<S-Tab>'] = actions.previous_location, -- Previous location (skips groups, cycles)
						['<space>l'] = actions.enter_win('list'), -- Focus list window
					},
				},

				hooks = {}, -- Described in Hooks section

				folds = {
					fold_closed = '',
					fold_open = '',
					folded = true, -- Automatically fold list on startup
				},

				indent_lines = {
					enable = true, -- Show indent guidelines
					icon = '│',
				},

				winbar = {
					enable = true, -- Enable winbar for the preview (requires neovim-0.8+)
				},

				use_trouble_qf = false -- Quickfix action will open trouble.nvim instead of built-in quickfix list
			})
		end
	},
	{ -- Diff view
		'sindrets/diffview.nvim',
		dependencies = { 'plenary.nvim' },
		config = function()
			require("diffview").setup({
				enhanced_diff_hl = true,
				use_icons = true,
				view = {
					merge_tool = {
						layout = "diff3_mixed",
						winbar_info = false,
						disable_diagnostics = true,
					},
					file_history = {
						layout = "diff2_horizontal",
						winbar_info = false,
					}
				}
			})
		end
	},
	{
		'nvim-treesitter/nvim-treesitter',
		lazy = true,
		event = { 'BufReadPost', 'BufNewFile' },
		config = function()
			require 'nvim-treesitter.configs'.setup {
				ensure_installed = { "python", "lua", "javascript", "typescript", "tsx", "html", "css", "json", "yaml", "toml",
					"bash", "cpp", "rust", "go", "dockerfile" },
				highlight = {
					enable = true,
					disable = {},
				},
			}
		end
	},
	{ -- Motion
		'phaazon/hop.nvim',
		keys = {
			{ "<Space>s", "<cmd>HopWord<CR>",            mode = { "n", "v" }, noremap = true },
			{ "<Space>l", "<cmd>HopWordCurrentLine<CR>", mode = { "n", "v" }, noremap = true },
			{ "<Space>k", "<cmd>HopLine<CR>",            mode = { "n", "v" }, noremap = true },
		},
		config = function()
			require('hop').setup({})
		end
	},
	{
		"folke/flash.nvim",
		event = "VeryLazy",
		opts = {
			modes = {
				search = {
					enabled = false,
				},
				char = {
					enabled = false,
				},
			},
		},
		keys = {
			{
				"<Space>v",
				mode = { "n" },
				function()
					require("flash").treesitter()
				end,
			},
		},
	},
	-- Filer
	{
		'nvim-tree/nvim-tree.lua',
		dependencies = {
			'b0o/nvim-tree-preview.lua',
			dependencies = {
				'nvim-lua/plenary.nvim',
			},
		},
		keys = {
			{ "fs", ":NvimTreeToggle<CR>" },
		},
		config = function()
			-- disable netrw at the very start of your init.lua
			vim.g.loaded_netrw = 1
			vim.g.loaded_netrwPlugin = 1

			-- set termguicolors to enable highlight groups
			vim.opt.termguicolors = true

			local function my_on_attach(bufnr)
				local api = require "nvim-tree.api"

				local function opts(desc)
					return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = false, silent = true, nowait = true }
				end

				local preview = require('nvim-tree-preview')
				vim.keymap.set('n', 'p', preview.watch, opts 'Preview (Watch)')
				vim.keymap.set('n', 'P', api.fs.paste, opts 'Paste')
				vim.keymap.set('n', '<Esc>', preview.unwatch, opts 'Close Preview/Unwatch')
				vim.keymap.set('n', '<C-f>', function() return preview.scroll(4) end, opts 'Scroll Down')
				vim.keymap.set('n', '<C-b>', function() return preview.scroll(-4) end, opts 'Scroll Up')

				vim.keymap.set('n', 'l', api.tree.change_root_to_node, opts('CD'))
				vim.keymap.set('n', 'h', api.tree.change_root_to_parent, opts('Up'))
				vim.keymap.set('n', 'a', api.fs.create, opts('Create'))
				vim.keymap.set('n', 'd', api.fs.remove, opts('Delete'))
				vim.keymap.set('n', 'D', api.fs.trash, opts('Trash'))
				vim.keymap.set('n', 'e', api.tree.expand_all, opts('Expand All'))
				vim.keymap.set('n', 'E', api.tree.collapse_all, opts('Collapse'))
				vim.keymap.set('n', 'q', api.tree.close, opts('Close'))
				vim.keymap.set('n', 'fs', api.tree.close, opts('Close'))
				vim.keymap.set('n', 'r', api.fs.rename, opts('Rename'))
				vim.keymap.set('n', 'H', api.tree.toggle_hidden_filter, opts('Toggle Dotfiles'))
				vim.keymap.set('n', 'o', api.node.open.edit, opts('Open'))
				vim.keymap.set('n', 'O', api.node.open.no_window_picker, opts('Open: No Window Picker'))
				vim.keymap.set('n', 'M', api.marks.bulk.move, opts('Move Bookmarked'))
				vim.keymap.set('n', 'm', api.marks.toggle, opts('Toggle Bookmark'))


				vim.keymap.set('n', '<C-e>', api.node.open.replace_tree_buffer, opts('Open: In Place'))
				vim.keymap.set('n', '<C-k>', api.node.show_info_popup, opts('Info'))
				vim.keymap.set('n', '<C-r>', api.fs.rename_sub, opts('Rename: Omit Filename'))
				vim.keymap.set('n', '<C-v>', api.node.open.vertical, opts('Open: Vertical Split'))
				vim.keymap.set('n', '<BS>', api.node.navigate.parent_close, opts('Close Directory'))
				vim.keymap.set('n', '<CR>', api.node.open.no_window_picker, opts('Open'))
				vim.keymap.set('n', '<C-o>', api.node.open.no_window_picker, opts('Open'))
				vim.keymap.set('n', 'B', api.tree.toggle_no_buffer_filter, opts('Toggle No Buffer'))
				vim.keymap.set('n', 'c', api.fs.copy.node, opts('Copy'))
				vim.keymap.set('n', 'C', api.tree.toggle_git_clean_filter, opts('Toggle Git Clean'))
				vim.keymap.set('n', '[c', api.node.navigate.git.prev, opts('Prev Git'))
				vim.keymap.set('n', ']c', api.node.navigate.git.next, opts('Next Git'))
				vim.keymap.set('n', ']e', api.node.navigate.diagnostics.next, opts('Next Diagnostic'))
				vim.keymap.set('n', '[e', api.node.navigate.diagnostics.prev, opts('Prev Diagnostic'))
				vim.keymap.set('n', 'F', api.live_filter.clear, opts('Clean Filter'))
				vim.keymap.set('n', 'g?', api.tree.toggle_help, opts('Help'))
				vim.keymap.set('n', 'gy', api.fs.copy.absolute_path, opts('Copy Absolute Path'))
				vim.keymap.set('n', 'I', api.tree.toggle_gitignore_filter, opts('Toggle Git Ignore'))
				vim.keymap.set('n', 'J', api.node.navigate.sibling.last, opts('Last Sibling'))
				vim.keymap.set('n', 'K', api.node.navigate.sibling.first, opts('First Sibling'))
				vim.keymap.set('n', 'R', api.tree.reload, opts('Refresh'))
				vim.keymap.set('n', 'S', api.tree.search_node, opts('Search'))
				vim.keymap.set('n', 'U', api.tree.toggle_custom_filter, opts('Toggle Hidden'))
				vim.keymap.set('n', 'x', api.fs.cut, opts('Cut'))
				vim.keymap.set('n', 'y', api.fs.copy.filename, opts('Copy Name'))
				vim.keymap.set('n', 'Y', api.fs.copy.relative_path, opts('Copy Relative Path'))
			end

			-- OR setup with some options
			require("nvim-tree").setup({
				on_attach = my_on_attach,
				sort_by = "case_sensitive",
				view = {
					width = 30,
				},
				renderer = {
					group_empty = true,
				},
				filters = {
					dotfiles = false,
				},
				actions = {
					open_file = {
						quit_on_open = true,
					}

				}
			})
		end
	},
	-- MISC
	'markonm/traces.vim',        -- live preview of replaces
	'nvim-lua/plenary.nvim',     -- dependency for many plugins
	'tpope/vim-repeat',          -- enhance . repeat
	"terryma/vim-expand-region", -- expand visual selection with +/_
	'dhruvasagar/vim-table-mode', -- markdown table mode
	'djoshea/vim-autoread',      -- auto reload edited file
	'tpope/vim-surround',        -- ysaw [, Ctrl-V + S + <tag>, ds', yss {, yss <tag,  cs" ', ...
	'tpope/vim-commentary',      -- comment/uncomment with visual selection + gc
	{                            -- Preview markdown on browser
		"iamcco/markdown-preview.nvim",
		cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
		ft = { "markdown" },
		build = function() vim.fn["mkdp#util#install"]() end,
	},
	{
		-- remove trailing whitespaces
		-- disable with `:DisableWhitespace `
		'ntpeters/vim-better-whitespace',
		config = function()
			vim.cmd('let g:better_whitespace_enabled=1')
			vim.cmd('let g:strip_whitespace_on_save=1')
			vim.cmd('let g:strip_whitespace_confirm=0')
		end,
	},
	{ -- fond/unfold
		'Wansmer/treesj',
		dependencies = { 'nvim-treesitter/nvim-treesitter' },
		config = function()
			require('treesj').setup({
				use_default_keymaps = false
			})
			vim.keymap.set('n', '<space>m', require('treesj').toggle)
		end,
	},
	{
		-- align selection
		'junegunn/vim-easy-align',
		keys = {
			{ "ga", mode = { "n", "v" }, "<Plug>(EasyAlign)" },
		},
	},
	{
		-- diagnostics
		"folke/trouble.nvim",
		opts = {}, -- for default options, refer to the configuration section for custom setup.
		cmd = "Trouble",
		keys = {
			{
				"T",
				"<cmd>Trouble diagnostics toggle focus=false filter.buf=0<cr>",
				desc = "Diagnostics (Trouble)",
			},
		},
	},
	{
		-- Enpower csv view
		"hat0uma/csvview.nvim",
		opts = {
			parser = { comments = { "#", "//" } },
		},
		cmd = { "CsvViewEnable", "CsvViewDisable", "CsvViewToggle" },
		keys = {
			{
				"<Space>t", mode = { "n" }, ":CsvViewToggle delimiter=, display_mode=border header_lnum=1<CR>" },
		},

	},
	{
		-- D2 renderer
		"terrastruct/d2-vim",
		ft = { "d2" },
	},
	{
		-- document generator
		"danymat/neogen",
		config = function()
			require('neogen').setup {
				enabled = true,
				input_after_comment = false,
			}
			local opts = { noremap = true, silent = true }
			vim.api.nvim_set_keymap("n", "<space>cm", ":Neogen<CR>", opts)
		end
	}
}
