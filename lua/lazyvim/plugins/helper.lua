return {
	-- Git diff
	{
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
	-- Motion
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
	{
		'phaazon/hop.nvim',
		keys = {
			{ "<Space>s", "<cmd>HopWord<CR>" },
			{ "<Space>l", "<cmd>HopWordCurrentLine<CR>", mode = { "n", "v" } },
			{ "<Space>k", "<cmd>HopLine<CR>" },
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
				vim.keymap.set('n', 'P', api.node.navigate.parent, opts('Parent Directory'))
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
	{
		-- Preview markdown on browser
		"iamcco/markdown-preview.nvim",
		cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
		ft = { "markdown" },
		build = function() vim.fn["mkdp#util#install"]() end,
	},
	{
		'Wansmer/treesj',
		dependencies = { 'nvim-treesitter/nvim-treesitter' },
		config = function()
			require('treesj').setup({})
			vim.keymap.set('n', '<space>m', require('treesj').toggle)
		end,
	},
	{
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
		"terrastruct/d2-vim",
		ft = { "d2" },
	}
}
