return {
	{
		-- Network request client
		"mistweaverco/kulala.nvim",
		lazy = true,
		keys = {
			{ "<space>ss", function() require("kulala").run() end,        mode = { "n", "v" }, desc = "Send request" },
			{ "<space>sa", function() require("kulala").run_all() end,    mode = { "n", "v" }, desc = "Send all request" },
			{ "<space>st", function() require("kulala").show_stats() end, mode = { "n" },      desc = "Open scratchpad" },
		},
		ft = { "http", "rest" },
		opts = {
			global_keymaps = false,
			global_keymaps_prefix = "<space>R",
			kulala_keymaps_prefix = "",
			ui = {
				split_direction = "horizontal",
			},
		},
		config = function(_, opts)
			require("kulala").setup(opts)
		end
	},
	{
		-- D2 renderer
		"terrastruct/d2-vim",
		lazy = true,
		keys = {
			{ "<space>dd", mode = { "n" }, ":D2Toggle<CR>" },
		},
		ft = { "d2" },
	},
	{
		-- diagnostics
		"folke/trouble.nvim",
		opts = {}, -- for default options, refer to the configuration section for custom setup.
		cmd = "Trouble",
		lazy = true,
		keys = {
			{
				"T",
				"<cmd>Trouble diagnostics toggle focus=false filter.buf=0<cr>",
				desc = "Diagnostics (Trouble)",
			},
		},
	},
	{ -- fond/unfold
		"Wansmer/treesj",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		lazy = true,
		keys = {
			{ "<space>m", mode = { "n" }, ":lua require('treesj').toggle()<CR>" },
		},
		config = function()
			require("treesj").setup({ use_default_keymaps = false })
		end,
	},
	{
		"kevinhwang91/nvim-ufo",
		dependencies = { "kevinhwang91/promise-async" },
		lazy = true,
		keys = {
			{
				"zf",
				function()
					local winid = vim.api.nvim_get_current_win()
					local cursor = vim.api.nvim_win_get_cursor(winid)
					local lnum = cursor[1]

					local foldlevel = vim.fn.foldlevel(lnum)
					if foldlevel > 0 then
						vim.cmd(lnum .. "foldclose")
					end
				end,
				mode = { "n" }
			},
			{ "zF", function() require("ufo").closeAllFolds() end,        mode = { "n" } },
			{ "zo", function() require("ufo").openFoldsExceptKinds() end, mode = { "n" } },
			{ "zO", function() require("ufo").openAllFolds() end,         mode = { "n" } },
		},
		config = function()
			-- vim.o.foldcolumn = "1" -- "0" is not bad
			vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
			vim.o.foldlevelstart = 99
			vim.o.foldenable = true

			require("ufo").setup({
				provider_selector = function(bufnr, filetype, buftype)
					return { "treesitter", "indent" }
				end
			})
		end
	},
	{
		"michaelb/sniprun",
		branch = "master",
		lazy = true,
		keys = {
			{ "<space>r", "<cmd>SnipRun<CR>",   mode = { "v" } },
			{ "<space>c", "<cmd>SnipClose<CR>", mode = { "n" } },
		},
		build = "sh install.sh",
		-- do "sh install.sh 1" if you want to force compile locally
		-- (instead of fetching a binary from the github release). Requires Rust >= 1.65
		config = function()
			require("sniprun").setup({
				display = { "TempFloatingWindow" },
				selected_interpreters = { "JS_TS_bun" },
				repl_enable = { "JS_TS_bun" }
			})
		end,
	},
}
