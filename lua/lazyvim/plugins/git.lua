return {
	{
		"tpope/vim-fugitive",
		keys = {
			{ '<C-g><C-g>', mode = { 'n' }, ':Git<CR>', silent = true },
		}
	},
	{
		'airblade/vim-gitgutter',
		keys = {
			{ 'ghp', "<Plug>(GitGutterPreviewHunk)" },
			{ 'ghs', "<Plug>(GitGutterStageHunk)" },
			{ 'ghu', "<Plug>(GitGutterUndoHunk)" },
		}
	},
	{
		"lewis6991/gitsigns.nvim",
		config = function()
			require('gitsigns').setup {
				signs = {
					add          = { text = '┃' },
		 			change       = { text = '┃' },
					delete       = { text = '▁' },
					topdelete    = { text = '▔' },
					changedelete = { text = '~' },
					untracked    = { text = '┆' },
				},
				signcolumn                   = true, -- Toggle with `:Gitsigns toggle_signs`
				numhl                        = false, -- Toggle with `:Gitsigns toggle_numhl`
				linehl                       = false, -- Toggle with `:Gitsigns toggle_linehl`
				word_diff                    = false, -- Toggle with `:Gitsigns toggle_word_diff`
				watch_gitdir                 = {
					interval = 1000,
					follow_files = true
				},
				attach_to_untracked          = true,
				current_line_blame           = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
				current_line_blame_opts      = {
					virt_text = true,
					virt_text_pos = 'eol', -- 'eol' | 'overlay' | 'right_align'
					delay = 1000,
					ignore_whitespace = false,
				},
				current_line_blame_formatter = '<author>, <author_time:%Y-%m-%d> - <summary>',
				sign_priority                = 100,
				update_debounce              = 100,
				status_formatter             = nil, -- Use default
				max_file_length              = 40000, -- Disable if file is longer than this (in lines)
				preview_config               = {
					-- Options passed to nvim_open_win
					border = 'single',
					style = 'minimal',
					relative = 'cursor',
					row = 0,
					col = 1
				},
				on_attach                    = function(bufnr)
					local gs = package.loaded.gitsigns

					local function map(mode, l, r, opts)
						opts = opts or {}
						opts.buffer = bufnr
						vim.keymap.set(mode, l, r, opts)
					end

					-- Navigation
					map('n', ']c', function()
						if vim.wo.diff then return ']c' end
						vim.schedule(function() gs.next_hunk() end)
						return '<Ignore>'
					end, { expr = true })

					map('n', '[c', function()
						if vim.wo.diff then return '[c' end
						vim.schedule(function() gs.prev_hunk() end)
						return '<Ignore>'
					end, { expr = true })

					-- Actions
					map({ 'n', 'v' }, '<Space>hs', ':Gitsigns stage_hunk<CR>')
					map({ 'n', 'v' }, '<Space>hr', ':Gitsigns reset_hunk<CR>')
					map('n', '<Space>hS', gs.stage_buffer)
					map('n', '<Space>hu', gs.undo_stage_hunk)
					map('n', '<Space>hR', gs.reset_buffer)
					map('n', '<Space>hp', gs.preview_hunk)
					map('n', '<Space>hb', function() gs.blame_line { full = true } end)
					map('n', '<Space>tb', gs.toggle_current_line_blame)
					map('n', '<Space>hd', gs.diffthis)
					map('n', '<Space>hD', function() gs.diffthis('~') end)
					map('n', '<Space>td', gs.toggle_deleted)

					-- Text object
					map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>')
				end
			}
		end,
	},
	-- {'pwntester/octo.nvim',
	-- dependencies = { 'plenary.nvim', 'telescope.nvim', 'nvim-web-devicons' },
	-- },
}
