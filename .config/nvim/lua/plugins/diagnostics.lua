return {
  -- Diagnostics panel
  {
    'folke/trouble.nvim',
    cmd = 'Trouble',
    keys = {
      { '<leader>xx', '<cmd>Trouble diagnostics toggle<cr>', desc = 'Diagnostics (Trouble)' },
      { '<leader>xd', '<cmd>Trouble diagnostics toggle filter.buf=0<cr>', desc = 'Buffer diagnostics' },
      { '<leader>xl', '<cmd>Trouble loclist toggle<cr>', desc = 'Location list' },
      { '<leader>xq', '<cmd>Trouble qflist toggle<cr>', desc = 'Quickfix list' },
    },
    opts = {},
  },
}
