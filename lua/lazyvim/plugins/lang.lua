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
			{ "<Space>gd", mode = { "n" }, ":GoDocBrowser<CR>" },
			{ "<Space>gi", mode = { "n" }, ":GoImpl " },
			{ "<Space>gs", mode = { "n" }, ":GoFillStruct<CR>" },
			{ "<Space>gt", mode = { "n" }, ":GoAddTag<CR>" },
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
	},
	{
		"maxandron/goplements.nvim",
		ft = "go",
		opts = {}
	},
	{ 'Saecki/crates.nvim',
		dependencies = { 'nvim-lua/plenary.nvim' },
		event = { "BufRead Cargo.toml" },
		config = function()
			local crates = require("crates")
			local opts = { silent = true }

			vim.keymap.set("n", "<Space>ct", crates.toggle, opts)
			vim.keymap.set("n", "<Space>cr", crates.reload, opts)

			vim.keymap.set("n", "<Space>cv", crates.show_versions_popup, opts)
			vim.keymap.set("n", "<Space>cf", crates.show_features_popup, opts)
			vim.keymap.set("n", "<Space>cd", crates.show_dependencies_popup, opts)

			vim.keymap.set("n", "<Space>cu", crates.update_crate, opts)
			vim.keymap.set("v", "<Space>cu", crates.update_crates, opts)
			vim.keymap.set("n", "<Space>cU", crates.upgrade_crate, opts)
			vim.keymap.set("v", "<Space>cU", crates.upgrade_crates, opts)
			-- vim.keymap.set("n", "<Space>ca", crates.update_all_crates, opts)
			vim.keymap.set("n", "<Space>cA", crates.upgrade_all_crates, opts)

			vim.keymap.set("n", "<Space>cx", crates.expand_plain_crate_to_inline_table, opts)
			vim.keymap.set("n", "<Space>cX", crates.extract_crate_into_table, opts)

			vim.keymap.set("n", "<Space>cH", crates.open_homepage, opts)
			vim.keymap.set("n", "<Space>cR", crates.open_repository, opts)
			vim.keymap.set("n", "<Space>cD", crates.open_documentation, opts)
			vim.keymap.set("n", "<Space>cC", crates.open_crates_io, opts)
		end
	}
}
