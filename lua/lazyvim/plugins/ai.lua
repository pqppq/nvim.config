return {
	{
		'Exafunction/windsurf.vim',
		config = function()
			vim.keymap.set('i', '<C-]>', function() return vim.fn['codeium#CycleCompletions'](1) end,
				{ expr = true, silent = false })
			vim.keymap.set('i', '<C-[>', function() return vim.fn['codeium#CycleCompletions'](-1) end,
				{ expr = true, silent = false })
			vim.keymap.set('i', '<C-;>', function() return vim.fn['codeium#Complete']() end, { expr = true, silent = true })
			vim.keymap.set('i', '<C-x>', function() return vim.fn['codeium#Clear']() end, { expr = true, silent = true })
		end
	},
	{
		"folke/sidekick.nvim",
		opts = {
			-- cli = {
			-- 	mux = {
			-- 		enabled = true,
			-- 		backend = "tmux",
			-- 	},
			-- },
		},
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
