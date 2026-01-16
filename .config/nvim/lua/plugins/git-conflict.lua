return {
  'akinsho/git-conflict.nvim',
  version = '*',
  event = 'BufReadPre',
  opts = {},
  keys = {
    { '<leader>gco', '<cmd>GitConflictChooseOurs<cr>', desc = 'Choose ours' },
    { '<leader>gct', '<cmd>GitConflictChooseTheirs<cr>', desc = 'Choose theirs' },
    { '<leader>gcb', '<cmd>GitConflictChooseBoth<cr>', desc = 'Choose both' },
    { '<leader>gcn', '<cmd>GitConflictChooseNone<cr>', desc = 'Choose none' },
    { '<leader>gcl', '<cmd>GitConflictListQf<cr>', desc = 'List conflicts' },
    { '[x', '<cmd>GitConflictPrevConflict<cr>', desc = 'Prev conflict' },
    { ']x', '<cmd>GitConflictNextConflict<cr>', desc = 'Next conflict' },
  },
}
