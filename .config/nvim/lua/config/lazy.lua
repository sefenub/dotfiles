-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Use system clipboard with normal vim copy/paste
vim.opt.clipboard = "unnamedplus"
vim.opt.termguicolors = true
vim.opt.signcolumn = "yes"
vim.opt.number = true
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.opt.foldlevel = 99
vim.opt.foldenable = true
vim.opt.ignorecase = true
vim.opt.smartcase = true

local opt = vim.opt

-- Tab settings (use spaces, 2-space default)
opt.expandtab = true      -- Convert tabs to spaces
opt.tabstop = 2          -- Number of spaces tabs count for
opt.shiftwidth = 2       -- Size of an indent
opt.softtabstop = 2      -- Number of spaces in tab when editing
opt.smartindent = true   -- Smart autoindenting on new lines

-- Setup lazy.nvim
require("lazy").setup({
  spec = {
    -- import your plugins
    { import = "plugins" },
    { "folke/todo-comments.nvim", opts = {} },
    { "folke/which-key.nvim", event = "VeryLazy" },
    {
    'nvim-telescope/telescope.nvim', tag = '*',
    dependencies = {
        'nvim-lua/plenary.nvim',
        -- optional but recommended
        { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
    },
	config = function()
	    require('telescope').setup({
	      pickers = {
		colorscheme = {
		  enable_preview = true  -- This enables live preview
		}
	      }
	    })
	  end,
}
  },
  -- Configure any other settings here. See the documentation for more details.
  -- colorscheme that will be used when installing plugins.
  install = { colorscheme = { "habamax" } },
  -- automatically check for plugin updates
  checker = { enabled = true },
},
{
	change_detection = {
		notify = true,
}
})

-- Load personal configs
require('config.user').setup()
