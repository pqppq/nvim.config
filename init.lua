-- load lazyvim
require("lazyvim")

-- set keymaps
vim.keymap.set('n', '<Space><Space>', ":let @/ = '\\<' . expand('<cword>') . '\\>'<CR>:set hlsearch<CR>")
vim.keymap.set('n', 'R', ":%s/<C-r>=expand('<cword>')<CR>//g<Left><Left>", { silent = true })
vim.keymap.set('n', 'm', 'daw')
vim.keymap.set('n', 'X', ':bdelete<CR>')
vim.keymap.set('n', '<C-s>', ':w<CR>', { silent = true })
vim.keymap.set('n', '<C-c>', '"+yiw') -- yank word under cursor
vim.keymap.set('i', 'jk', '<Esc>')
vim.keymap.set('i', '<C-o>', '()<Left>')
vim.keymap.set('i', '<C-l>', '{}<Left>')
vim.keymap.set('i', '<C-t>', '<><Left>')
vim.keymap.set('i', '<C-u>', '""<Left>')
vim.keymap.set('i', '<C-k>', '<C-\\><C-n>')
vim.keymap.set('i', '<C-s>', '<Esc>:w<CR>a', { silent = true })
vim.keymap.set('v', 'J', ":move '>+1<CR>gv-gv")
vim.keymap.set('v', 'K', ":move '<-2<CR>gv-gv")
-- vim.keymap.set('n', '<Space>wj',    '<cmd>resize +3<cr>')
-- vim.keymap.set('n', '<Space>wk',  '<cmd>resize -3<cr>')
-- vim.keymap.set('n', '<Space>wh',  '<cmd>vertical resize -3<cr>')
-- vim.keymap.set('n', '<Space>wl', '<cmd>vertical resize +3<cr>')
vim.cmd("cnoreabbrev <expr> s getcmdtype() .. getcmdline() ==# ':s' ? [getchar(), ''][1] .. '%s///Ig<Left><Left><Left>' : 's'")

vim.cmd('filetype plugin indent on')
vim.cmd('autocmd FileType go inoremap <C-e> :=')
vim.cmd('autocmd FileType rust inoremap <C-e> ::')
vim.cmd('autocmd FileType haskell inoremap <C-e> ::')
vim.cmd('autocmd FileType haskell set expandtab')

-- set options
vim.g.netrw_http_cmd = 'open'
vim.opt.laststatus = 2
vim.opt.number = true
vim.opt.statusline = '%t%m%=[%l/%L]'
vim.opt.ambiwidth = 'single'
vim.opt.hidden = true
vim.opt.cmdheight = 1
vim.opt.guicursor = 'n-v-c:block-Cursor,i-r:hor20'
vim.opt.updatetime = 50
vim.opt.ttyfast = true
vim.opt.autowrite = true
vim.opt.backup = true
vim.opt.backupdir = '/tmp/.vim/backup'
vim.opt.backupext = '.backup'
vim.opt.undofile = true
vim.opt.undodir = '/tmp/.vim/backup'
vim.opt.wildmenu = true
vim.opt.wildmode = 'full'
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.incsearch = true
vim.opt.hlsearch = false
vim.opt.confirm = true
vim.opt.errorbells = false
vim.opt.showmatch = true
vim.opt.matchtime = 1
vim.opt.display = 'lastline'
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.swapfile = false
vim.opt.clipboard:append 'unnamed'
vim.opt.mouse = '' -- disable mouse touch
-- vim.opt.mouse = 'a'
vim.opt.signcolumn = 'auto:2'

vim.wo.wrap = false
-- vim.wo.list = true
vim.wo.linebreak = true

-- set highlight
vim.cmd('hi! StatusLine guibg=white guifg=black')
vim.cmd('hi! Cursor guibg=#DFE015 guifg=#DFE015')
vim.cmd('hi! DiffAdd ctermbg=NONE guibg=#083700')
vim.cmd('hi! DiffDelete ctermbg=NONE guibg=#6E0801')
vim.cmd('hi! DiffChange ctermbg=NONE guibg=#1C0690')

-- custom diagnostic
local function format(diagnostic)
	local icon = '◀'
	if diagnostic.severity == vim.diagnostic.severity.WARN then
		icon = '⚠'
	end
	if diagnostic.severity == vim.diagnostic.severity.HINT then
		icon = '☜'
	end
	if diagnostic.severity == vim.diagnostic.severity.INFO then
		icon = '☜'
	end
	if diagnostic.severity == vim.diagnostic.severity.OTHER then
		icon = '⬅'
	end

	local message = string.format("%s %s", icon, diagnostic.message)
	return message
end

vim.diagnostic.config({
	float = true,
	update_in_insert = true,
	signs = false,
	virtual_text = {
		prefix = '',
		format = format,
		spacing = 2,
	},
})
