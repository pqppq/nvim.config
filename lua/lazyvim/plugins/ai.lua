return {
	{
		"Exafunction/windsurf.vim",
		event = { "InsertEnter" },
		keys = {
			{ "<C-]>", function() return vim.fn["codeium#CycleCompletions"](1) end,  mode = "i", expr = true, silent = false, desc = "Codeium Next" },
			{ "<C-[>", function() return vim.fn["codeium#CycleCompletions"](-1) end, mode = "i", expr = true, silent = false, desc = "Codeium Prev" },
			{ "<C-;>", function() return vim.fn["codeium#Complete"]() end,           mode = "i", expr = true, silent = true,  desc = "Codeium Complete" },
			{ "<C-x>", function() return vim.fn["codeium#Clear"]() end,              mode = "i", expr = true, silent = true,  desc = "Codeium Clear" },
		},
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
