return {
  'akinsho/toggleterm.nvim',
  version = '*',
  keys = {
    { '<leader>tf', '<cmd>1ToggleTerm direction=float<cr>', desc = 'Terminal (float)' },
    { '<leader>tv', '<cmd>2ToggleTerm direction=vertical size=80<cr>', desc = 'Terminal (vertical)' },
    { '<leader>th', '<cmd>3ToggleTerm direction=horizontal size=15<cr>', desc = 'Terminal (horizontal)' },
    { '<A-i>', '<cmd>ToggleTerm<cr>', mode = { 'n', 't' }, desc = 'Toggle terminal' },
  },
  opts = {
    shade_terminals = false,
  },
}
