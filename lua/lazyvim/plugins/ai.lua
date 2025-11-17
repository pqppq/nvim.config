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
		"NickvanDyke/opencode.nvim",
		dependencies = {
			-- Recommended for `ask()` and `select()`.
			-- Required for `snacks` provider.
			---@module 'snacks' <- Loads `snacks.nvim` types for configuration intellisense.
			{ "folke/snacks.nvim", opts = { input = {}, picker = {}, terminal = {} } },
		},
		config = function()
			---@type opencode.Opts
			vim.g.opencode_oets = {
				-- Your configuration, if any — see `lua/opencode/config.lua`, or "goto definition".
			}

			-- Required for `opts.auto_reload`.
			vim.o.autoread = true

			-- Recommended/example keymaps.
			-- toggle opencode term
			vim.keymap.set({ "n", "t" }, "<space>oo", function() require("opencode").toggle() end, { desc = "Toggle opencode" })
			vim.keymap.set({ "n", "x" }, "<space>oa", function() require("opencode").ask("@this: ", { submit = true }) end,
				{ desc = "Ask opencode" })
			vim.keymap.set({ "n", "x" }, "<space>ox", function() require("opencode").select() end,
				{ desc = "Execute opencode action…" })
			vim.keymap.set({ "n", "x" }, "<space>oA", function() require("opencode").prompt("@this") end,
				{ desc = "Add to opencode" })
			vim.keymap.set("t", "<S-u>", function() require("opencode").command("session.half.page.up") end,
				{ desc = "opencode half page up" })
			vim.keymap.set("t", "<S-d>", function() require("opencode").command("session.half.page.down") end,
				{ desc = "opencode half page down" })
			-- You may want these if you stick with the opinionated "<C-a>" and "<C-x>" above — otherwise consider "<leader>o".
			vim.keymap.set('n', '+', '<C-a>', { desc = 'Increment', noremap = true })
			vim.keymap.set('n', '-', '<C-x>', { desc = 'Decrement', noremap = true })
		end,
	}
}
