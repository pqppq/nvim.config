return {
	{
		-- Network request client
		"mistweaverco/kulala.nvim",
		keys = {
			{ "<space>ss", function() require("kulala").run() end,     desc = "Send request" },
			{ "<space>st", function() require("kulala").show_stats() end,  desc = "Open scratchpad" },
		},
		ft = { "http", "rest" },
		opts = {
			global_keymaps = false,
			global_keymaps_prefix = "<space>R",
			kulala_keymaps_prefix = "",
		},
		config = function(_, opts)
			require("kulala").setup(opts)
		end
	},
	{
		-- D2 renderer
		"terrastruct/d2-vim",
		ft = { "d2" },
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
}
