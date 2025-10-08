return {
	{
		'nvim-orgmode/orgmode',
		config = function()
			-- Treesitter configuration
			require('nvim-treesitter.configs').setup {
				-- If TS highlights are not enabled at all, or disabled via `disable` prop,
				-- highlighting will fallback to default Vim syntax highlighting
				highlight = {
					enable = true,
					-- Required for spellcheck, some LaTex highlights and
					-- code block highlights that do not have ts grammar
					additional_vim_regex_highlighting = { 'org' },
				},
				ensure_installed = { 'org' }, -- Or run :TSUpdate org
			}

			require('orgmode').setup({
				org_agenda_files = { '~/orgmode/*' },
				org_todo_keywords = { 'TODO', 'STARTED', 'WAITING', '|', 'DONE', 'CANCELLED' },
			})
		end
	},
	{
		"kosayoda/nvim-lightbulb",
		config = function()
			require("nvim-lightbulb").setup({
				autocmd = { enabled = true },
				sign = { enabled = false },
				virtual_text = { enabled = true },
			})
		end
	},
	"mg979/vim-visual-multi",
	"kevinhwang91/nvim-bqf",
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
	-- {
	-- 	"mattn/emmet-vim",
	-- 	config = function()
	-- 		-- vim.cmd("let g:user_emmet_mode=''")
	-- 		-- vim.cmd("let g:user_emmet_leader_key='<c-e>'")
	-- 	end
	-- },
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

		end
	},
	'jiangmiao/auto-pairs',
	'tpope/vim-surround',
	'tpope/vim-commentary',
	"terryma/vim-expand-region",
	{
		'ntpeters/vim-better-whitespace',
		config = function()
			vim.cmd('let g:better_whitespace_enabled=1')
			vim.cmd('let g:strip_whitespace_on_save=1')
			vim.cmd('let g:strip_whitespace_confirm=0')
		end,
	},
	{
		'junegunn/vim-easy-align',
		keys = {
			{ "ga", mode = { "n", "v" }, "<Plug>(EasyAlign)" },
		},
	},
	{
		"folke/trouble.nvim",
		lazy = true,
		keys = {
			{ "T", ":TroubleToggle<CR>" },
		},
		config = function()
			require('trouble').setup {
				position = "bottom", -- position of the list can be: bottom, top, left, right
				height = 8, -- height of the trouble list when position is top or bottom
				width = 50, -- width of the list when position is left or right
				icons = true, -- use devicons for filenames
				mode = "workspace_diagnostics", -- "workspace_diagnostics", "document_diagnostics", "quickfix", "lsp_references", "loclist"
				fold_open = "", -- icon used for open folds
				fold_closed = "", -- icon used for closed folds
				group = true, -- group results by file
				padding = true, -- add an extra new line on top of the list
				action_keys = {
					-- key mappings for actions in the trouble list
					-- map to {} to remove a mapping, for example:
					-- close = {},
					close = "q",                 -- close the list
					cancel = "<esc>",            -- cancel the preview and get back to your last window / buffer / cursor
					refresh = "r",               -- manually refresh
					jump = { "<cr>", "<tab>" },  -- jump to the diagnostic or open / close folds
					open_split = { "<c-x>" },    -- open buffer in new split
					open_vsplit = { "<c-v>" },   -- open buffer in new vsplit
					open_tab = { "<c-t>" },      -- open buffer in new tab
					jump_close = { "o" },        -- jump to the diagnostic and close the list
					toggle_mode = "m",           -- toggle between "workspace" and "document" diagnostics mode
					toggle_preview = "P",        -- toggle auto_preview
					hover = "K",                 -- opens a small popup with the full multiline message
					preview = "p",               -- preview the diagnostic location
					close_folds = { "zM", "zm" }, -- close all folds
					open_folds = { "zR", "zr" }, -- open all folds
					toggle_fold = { "zA", "za" }, -- toggle fold of current file
					previous = "k",              -- previous item
					next = "j"                   -- next item
				},
				indent_lines = true,           -- add an indent guide below the fold icons
				auto_open = false,             -- automatically open the list when you have diagnostics
				auto_close = true,             -- automatically close the list when you have no diagnostics
				auto_preview = false,          -- automatically preview the location of the diagnostic. <esc> to close preview and go back to last window
				auto_fold = false,             -- automatically fold a file trouble list at creation
				auto_jump = { "lsp_definitions" }, -- for the given modes, automatically jump if there is only a single result
				signs = {
					-- icons / text used for a diagnostic
					error = "🌶️",
					warning = "🍄",
					hint = "🍞",
					information = "🍺",
					other = "﫠"
				},
				use_diagnostic_signs = false -- enabling this will use the signs defined in your lsp client
			}
		end
	},
	{
		'L3MON4D3/LuaSnip',
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
			require("luasnip.loaders.from_vscode").load({ paths = "~/.config/nvim/snipets/friendly-snippets" }) -- Load snippets from my-snippets folder

			require("luasnip.loaders.from_lua").lazy_load({ paths = "~/.config/nvim/snipets/luasnip" })

			-- You can also use lazy loading so snippets are loaded on-demand, not all at once (may interfere with lazy-loading luasnip itself).
			-- require("luasnip.loaders.from_vscode").lazy_load() -- You can pass { paths = "./my-snippets/"} as well
			require("luasnip.loaders.from_vscode").lazy_load({ paths = { "~/.config/nvim/vscode-snippets" } }) -- You can pass { paths = "./my-snippets/"} as well
			require("luasnip.loaders.from_vscode").lazy_load({
				paths = { vim.fn.stdpath("data") .. "/site/pack/packer/opt/friendly-snippets" },
			}) -- You can pass { paths = "./my-snippets/"} as well

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
		"nvim-telescope/telescope.nvim",
		dependeicies = { "plenary.nvim" },
		keys = {
			{ "<Space>ff", "<cmd>Telescope find_files hidden=true theme=dropdown<CR>" },
			{ "<Space>fj", "<cmd>Telescope live_grep theme=dropdown<CR>" },
			{ "<Space>b",  "<cmd>Telescope buffers theme=dropdown<CR>" },
			{ "<Space>fs", "<cmd>Telescope current_buffer_fuzzy_find theme=dropdown<CR>" },
			-- git
			{ "<Space>gc", "<cmd>Telescope git_commits<CR>" },
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
				shell = '/bin/zsh',   -- change the default shell
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
		"xiyaowong/transparent.nvim",
		config = function()
			require("transparent").setup({ -- Optional, you don't have to run setup.
				groups = {                -- table: default groups
					'Normal', 'NormalNC', 'Comment', 'Constant', 'Special', 'Identifier',
					'Statement', 'PreProc', 'Type', 'Underlined', 'Todo', 'String', 'Function',
					'Conditional', 'Repeat', 'Operator', 'Structure', 'LineNr', 'NonText',
					'SignColumn', 'CursorLineNr', 'EndOfBuffer',
				},
				extra_groups = {}, -- table: additional groups that should be cleared
				exclude_groups = {}, -- table: groups you don't want to clear
			})
		end

	},
	{
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
				vim.api.nvim_set_keymap('v', '<Space>r', '<Plug>SnipRun<CR>', { silent = true }),
				vim.api.nvim_set_keymap('n', '<Space>r', '<Plug>SnipRun<CR>', { silent = true }),
				vim.api.nvim_set_keymap('n', '<Space>c', '<Plug>SnipClose<CR>', { silent = true }),
				vim.api.nvim_set_keymap('n', '<Space>r', '<Plug>SnipRunOperator<CR>', { silent = true }),

				display = { "Terminal" },
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

			vim.keymap.set('n', 'zR', require('ufo').openAllFolds)
			vim.keymap.set('n', 'zr', require('ufo').openFoldsExceptKinds)
			vim.keymap.set('n', 'zM', require('ufo').closeAllFolds)
			vim.keymap.set('n', 'zm', function()
				local winid = vim.api.nvim_get_current_win()
				local cursor = vim.api.nvim_win_get_cursor(winid)
				local lnum = cursor[1]

				local foldlevel = vim.fn.foldlevel(lnum)
				if foldlevel > 0 then
					vim.cmd(lnum .. "foldclose")
				end
			end)

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
	}
}
