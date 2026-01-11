return {
	-- Go
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
			{ "<Space>gd",  mode = { "n" }, ":GoDocBrowser<CR>" },
			{ "<Space>gi",  mode = { "n" }, ":GoImplements<CR>" },
			{ "<Space>ggi", mode = { "n" }, ":GoImpl " },
			{ "<Space>gs",  mode = { "n" }, ":GoFillStruct<CR>" },
			{ "<Space>gt",  mode = { "n" }, ":GoAddTag<CR>" },
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
		"maxandron/goplements.nvim",
		ft = "go",
		opts = {}
	},
	-- Rust
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
		"Saecki/crates.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		event = { "BufRead Cargo.toml" },
		config = function()
			local group = vim.api.nvim_create_augroup("CratesNvimKeys", { clear = true })
			vim.api.nvim_create_autocmd({ "BufEnter", "FileType" }, {
				group = group,
				pattern = "Cargo.toml",
				callback = function(args)
					local bufnr = args.buf
					local crates = require("crates")
					local function map(mode, lhs, rhs)
						vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, silent = true, noremap = true })
					end
					map("n", "<Space>ct", crates.toggle)
					map("n", "<Space>cr", crates.reload)
					map("n", "<Space>cv", crates.show_versions_popup)
					map("n", "<Space>cf", crates.show_features_popup)
					map("n", "<Space>cd", crates.show_dependencies_popup)
					map("n", "<Space>cu", crates.update_crate)
					map("v", "<Space>cu", crates.update_crates)
					map("n", "<Space>cA", crates.upgrade_all_crates)
					map("n", "<Space>cx", crates.expand_plain_crate_to_inline_table)
					map("n", "<Space>cX", crates.extract_crate_into_table)
					map("n", "<Space>cH", crates.open_homepage)
					map("n", "<Space>cR", crates.open_repository)
					map("n", "<Space>cD", crates.open_documentation)
					map("n", "<Space>cC", crates.open_crates_io)
				end,
			})
		end,
	}
}
