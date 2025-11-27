-- load lazyvim
require("lazyvim")

-- set options
vim.api.nvim_set_keymap('n', '<Space><Space>', ":let @/ = '\\<' . expand('<cword>') . '\\>'<CR>:set hlsearch<CR>", { noremap = true })
vim.api.nvim_set_keymap('n', 'R', ":%s/<C-r>=expand('<cword>')<CR>//g<Left><Left>", { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', 'm', 'daw', { noremap = true })
vim.api.nvim_set_keymap('n', '<C-I>', '<Tab>', { noremap = true })
vim.api.nvim_set_keymap('n', 'X', ':bdelete<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<C-S>', ':w<CR>', { noremap = true })
vim.api.nvim_set_keymap('i', 'jk', '<Esc>', { noremap = true })
vim.api.nvim_set_keymap('i', '<C-o>', '()<Left>', { noremap = true })
vim.api.nvim_set_keymap('i', '<C-l>', '{}<Left>', { noremap = true })
vim.api.nvim_set_keymap('i', '<C-t>', '<><Left>', { noremap = true })
vim.api.nvim_set_keymap('i', '<C-u>', '""<Left>', { noremap = true })
vim.api.nvim_set_keymap('i', '<C-r>', '[]<Left>', { noremap = true })
vim.api.nvim_set_keymap('i', '<C-k>', '<C-\\><C-n>', { noremap = true })
vim.api.nvim_set_keymap('v', 'J', ":move '>+1<CR>gv-gv", { noremap = true })
vim.api.nvim_set_keymap('v', 'K', ":move '<-2<CR>gv-gv", { noremap = true })

vim.cmd('autocmd FileType go inoremap <C-e> :=')
vim.cmd('autocmd FileType rust inoremap <C-e> ::')
vim.cmd('autocmd FileType haskell inoremap <C-e> ::')
vim.cmd('autocmd FileType haskell set expandtab')

vim.cmd('filetype plugin indent on')
vim.cmd("cnoreabbrev <expr> s getcmdtype() .. getcmdline() ==# ':s' ? [getchar(), ''][1] .. '%s///Ig<Left><Left><Left>' : 's'")

vim.g.netrw_http_cmd = 'open'
vim.opt.laststatus = 2
vim.opt.statusline = '%t'
vim.opt.statusline:append '%m'
vim.opt.statusline:append '%='
vim.opt.statusline:append '[%l/%L]'
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
vim.opt.shiftwidth = 2
vim.opt.swapfile = false
vim.opt.clipboard:append 'unnamed'
vim.opt.mouse = '' -- disable mouse touch
vim.opt.signcolumn = 'auto:2'

vim.wo.wrap = false
-- vim.wo.list = true
vim.wo.linebreak = true

-- classic style status bar
vim.cmd('hi! StatusLine guibg=white guifg=black')

vim.cmd('hi! Cursor guibg=#DFE015 guifg=#DFE015')

vim.cmd('hi! DiffAdd ctermbg=NONE guibg=#083700')
vim.cmd('hi! DiffDelete ctermbg=NONE guibg=#6E0801')
vim.cmd('hi! DiffChange ctermbg=NONE guibg=#1C0690')

local function format(diagnostic)
	local icon = '🐛'
	if diagnostic.severity == vim.diagnostic.severity.WARN then
		icon = '🌶️'
	end
	if diagnostic.severity == vim.diagnostic.severity.HINT then
		icon = '🥜'
	end
	if diagnostic.severity == vim.diagnostic.severity.INFO then
		icon = '🍕'
	end
	if diagnostic.severity == vim.diagnostic.severity.OTHER then
		icon = ''
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
