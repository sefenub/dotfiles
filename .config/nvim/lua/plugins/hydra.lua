return {
  'nvimtools/hydra.nvim',
  config = function()
    local Hydra = require('hydra')

    Hydra({
      name = 'Window resize',
      mode = 'n',
      body = '<C-w>',
      heads = {
        { '+', '<cmd>resize +2<cr>' },
        { '-', '<cmd>resize -2<cr>' },
        { '<', '<cmd>vertical resize -2<cr>' },
        { '>', '<cmd>vertical resize +2<cr>' },
        { '=', '<cmd>wincmd =<cr>', { exit = true, desc = 'equalize' } },
      },
    })
  end,
}
