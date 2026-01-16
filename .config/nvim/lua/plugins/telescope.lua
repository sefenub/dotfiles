-- lua/plugins/telescope.lua
return {
  'nvim-telescope/telescope.nvim',
  cmd = 'Telescope',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'folke/which-key.nvim',
  },
  config = function()
    require('telescope').setup({
      defaults = {
        sorting_strategy = 'ascending',
        layout_config = { prompt_position = 'top' },
      },
      pickers = {
        colorscheme = {
          enable_preview = true,
        }
      }
    })
  end,
  keys = {
    { '<leader>ff', '<cmd>Telescope find_files<cr>', desc = 'Find files' },
    { '<leader>fg', '<cmd>Telescope live_grep<cr>', desc = 'Live grep' },
    { '<leader>fb', '<cmd>Telescope buffers<cr>', desc = 'Buffers' },
    { '<leader>fh', '<cmd>Telescope help_tags<cr>', desc = 'Help tags' },
    { '<leader>fc', '<cmd>Telescope colorscheme<cr>', desc = 'Colorschemes' },
    { '<leader>fr', '<cmd>Telescope oldfiles<cr>', desc = 'Recent files' },
  },
}
