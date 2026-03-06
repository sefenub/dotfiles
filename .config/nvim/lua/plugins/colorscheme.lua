-- Save colorscheme on change
vim.api.nvim_create_autocmd('ColorScheme', {
  callback = function(args)
    vim.g.CURRENT_COLORSCHEME = args.match
  end,
})

-- Restore colorscheme after plugins load
vim.api.nvim_create_autocmd('VimEnter', {
  once = true,
  callback = function()
    if vim.g.CURRENT_COLORSCHEME then
      pcall(vim.cmd.colorscheme, vim.g.CURRENT_COLORSCHEME)
    end
  end,
})

return {
  {
    'catppuccin/nvim',
    name = 'catppuccin',
    priority = 1000,
    lazy = false,
    opts = {
      integrations = {
        cmp = true,
        gitsigns = true,
        treesitter = true,
        notify = true,
        mini = true,
        telescope = { enabled = true },
        which_key = true,
        indent_blankline = { enabled = true },
        native_lsp = {
          enabled = true,
          underlines = {
            errors = { "undercurl" },
            hints = { "undercurl" },
            warnings = { "undercurl" },
            information = { "undercurl" },
          },
        },
      },
    },
  },
  { "ellisonleao/gruvbox.nvim" }

}
