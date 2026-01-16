return {
  -- Animated indent scope line
  {
    'echasnovski/mini.indentscope',
    event = { 'BufReadPost', 'BufNewFile' },
    config = function()
      require('mini.indentscope').setup({
        symbol = '│',
        draw = {
          animation = require('mini.indentscope').gen_animation.none(),
        },
      })
    end,
  },

  -- Auto pairs
  {
    'echasnovski/mini.pairs',
    event = 'InsertEnter',
    opts = {},
  },


  -- Surround actions (add, delete, replace surroundings)
  {
    'echasnovski/mini.surround',
    event = { 'BufReadPost', 'BufNewFile' },
    opts = {},
  },

  -- Better text objects (around/inside)
  {
    'echasnovski/mini.ai',
    event = { 'BufReadPost', 'BufNewFile' },
    opts = {},
  },

  -- Comment lines with gc
  {
    'echasnovski/mini.comment',
    event = { 'BufReadPost', 'BufNewFile' },
    opts = {},
  },

  -- Highlight trailing whitespace
  {
    'echasnovski/mini.trailspace',
    event = { 'BufReadPost', 'BufNewFile' },
    opts = {},
  },
}
