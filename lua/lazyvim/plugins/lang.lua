return {
	{
		"ray-x/go.nvim",
		dependencies = { -- optional packages
			"ray-x/guihua.lua",
			"neovim/nvim-lspconfig",
			"nvim-treesitter/nvim-treesitter",
		},
		opts = {
			-- lsp_keymaps = false,
			-- other options
		},
		ft = { "go", 'gomod' },
		keys = {
			{ "<Space>gd",  mode = { "n" }, ":GoDocBrowser<CR>" },
			{ "<Space>gi", mode = { "n" }, ":GoImpl " },
			{ "<Space>gs", mode = { "n" }, ":GoFillStruct<CR>" },
			{ "<Space>gt",  mode = { "n" }, ":GoAddTag<CR>" },
		},
		config = function(lp, opts)
			require("go").setup(opts)
			local format_sync_grp = vim.api.nvim_create_augroup("GoFormat", {})
			vim.api.nvim_create_autocmd("BufWritePre", {
				pattern = "*.go",
				callback = function()
					require('go.format').goimports()
				end,
				group = format_sync_grp,
			})
		end,
		event = { "CmdlineEnter" },
		build = ':lua require("go.install").update_all_sync()' -- if you need to install/update all binaries
	},
	{
		'mrcjkb/rustaceanvim',
		version = '^4', -- Recommended
		ft = { 'rust' },
		lazy = false,
		keys = {
			{
				"<Space>e", mode = { "n" }, ":RustLsp expandMacro<CR>" },
		},
	}
}
