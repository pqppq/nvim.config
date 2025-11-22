-- load lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)
vim.g.mapleader = '<Space>'

require('lazy').setup('lazyvim/plugins')
-- vim.cmd.colorscheme('iceberg')
-- vim.cmd.colorscheme('catppuccin')vim

vim.cmd("hi clear")
-- vim.cmd("colorscheme vim")
-- vim.cmd("colorscheme rose-pine")
-- vim.cmd("colorscheme catppuccin")
-- vim.cmd("set notermguicolors")
