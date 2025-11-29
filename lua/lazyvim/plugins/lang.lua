return {
	{
		"ray-x/go.nvim",
		dependencies = { -- optional packages
			"ray-x/guihua.lua",
			"neovim/nvim-lspconfig",
			"nvim-treesitter/nvim-treesitter",
		},
		lazy = true,
		opts = {
			-- lsp_keymaps = false,
			-- other options
		},
		ft = { "go", "gomod" },
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
					require("go.format").goimports()
				end,
				group = format_sync_grp,
			})
		end,
		event = { "CmdlineEnter" },
		build = ":lua require('go.install').update_all_sync()" -- if you need to install/update all binaries
	},
	{
		"mrcjkb/rustaceanvim",
		version = "^4", -- Recommended
		ft = { "rust" },
		lazy = true,
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
	{
		"Saecki/crates.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		lazy = true,
		event = { "BufRead Cargo.toml" },
		keys = {
			{ "<Space>ct", ":lua require('crates').toggle()<CR>",                             mode = { "n" } },
			{ "<Space>cr", ":lua require('crates').reload()<CR>",                             mode = { "n" } },
			{ "<Space>cv", ":lua require('crates').show_versions_popup()<CR>",                mode = { "n" } },
			{ "<Space>cf", ":lua require('crates').show_features_popup()<CR>",                mode = { "n" } },
			{ "<Space>cd", ":lua require('crates').show_dependencies_popup()<CR>",            mode = { "n" } },
			{ "<Space>cu", ":lua require('crates').update_crate()<CR>",                       mode = { "n" } },
			{ "<Space>cu", ":lua require('crates').update_crates()<CR>",                      mode = { "v" } },
			{ "<Space>cA", ":lua require('crates').upgrade_all_crates()<CR>",                 mode = { "n" } },
			{ "<Space>cx", ":lua require('crates').expand_plain_crate_to_inline_table()<CR>", mode = { "n" } },
			{ "<Space>cX", ":lua require('crates').extract_crate_into_table()<CR>",           mode = { "n" } },
			{ "<Space>cH", ":lua require('crates').open_homepage()<CR>",                      mode = { "n" } },
			{ "<Space>cR", ":lua require('crates').open_repository()<CR>",                    mode = { "n" } },
			{ "<Space>cD", ":lua require('crates').open_documentation()<CR>",                 mode = { "n" } },
			{ "<Space>cC", ":lua require('crates').open_crates_io()<CR>",                     mode = { "n" } },
		},
	}
}
