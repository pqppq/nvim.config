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
	}
}
