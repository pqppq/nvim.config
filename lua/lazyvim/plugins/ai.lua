return {
	{
		"Exafunction/windsurf.vim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"hrsh7th/nvim-cmp",
		},
		keys = {
			{
				"<tab>",
				function()
					-- Fallback to a literal <Tab> if Codeium is unavailable
					if vim.fn.exists("*codeium#Accept") == 1 then
						return vim.fn["codeium#Accept"]()
					end
					return vim.api.nvim_replace_termcodes("<Tab>", true, true, true)
				end,
				mode = "i",
				expr = true,
				silent = true,
				desc = "Codeium Accept"
			},
			{
				"<C-[>",
				function()
					if vim.fn.exists("*codeium#CycleCompletions") == 1 then
						return vim.fn["codeium#CycleCompletions"](1)
					end
					return vim.api.nvim_replace_termcodes("<C-[>", true, true, true)
				end,
				mode = "i",
				expr = true,
				silent = false,
				desc = "Codeium Next"
			},
			{
				"<C-]>",
				function()
					if vim.fn.exists("*codeium#CycleCompletions") == 1 then
						return vim.fn["codeium#CycleCompletions"](-1)
					end
					return vim.api.nvim_replace_termcodes("<C-]>", true, true, true)
				end,
				mode = "i",
				expr = true,
				silent = false,
				desc = "Codeium Prev"
			},
		},
		config = function()
			local ok, codeium = pcall(require, "codeium")
			if ok then
				codeium.setup({
					-- Optionally disable cmp source if using virtual text only
					enable_cmp_source = false,
					virtual_text = {
						enabled = true,
						manual = true,
					}
				})
			end
		end
	},
	{
		"folke/sidekick.nvim",
		lazy = true,
		opts = {},
		keys = {
			{
				"<space>aa",
				function() require("sidekick.cli").toggle({ name = "opencode", focus = true }) end,
				desc = "Sidekick Toggle CLI",
			},
			{
				"<space>ad",
				function() require("sidekick.cli").close() end,
				desc = "Detach a CLI Session",
			},
			{
				"<space>af",
				function() require("sidekick.cli").send({ msg = "{file}" }) end,
				desc = "Send File",
			},
			{
				"<space>at",
				function() require("sidekick.cli").send({ msg = "{this}" }) end,
				mode = { "x", "n" },
				desc = "Send This Block(Function, Class, etc.)",
			},
			{
				"<space>av",
				function() require("sidekick.cli").send({ msg = "{selection}" }) end,
				mode = { "x" },
				desc = "Send Visual Selection",
			},
			{
				"<space>ap",
				function() require("sidekick.cli").prompt() end,
				mode = { "n", "x" },
				desc = "Sidekick Select Prompt",
			},
		},
	},
}
