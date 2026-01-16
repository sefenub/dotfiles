return {
  'folke/snacks.nvim',
  priority = 1000,
  lazy = false,
  opts = {
    -- Better handling of big files
    bigfile = { enabled = true },

    explorer = { enabled = true },

    -- Dashboard/start screen
    dashboard = { enabled = true },

    -- Better vim.ui.input
    input = { enabled = true },

    -- Notification system
    notifier = { enabled = true },

    -- Quick file access
    quickfile = { enabled = true },

    -- Smooth scrolling
    scroll = { enabled = true },

    -- Status column with git signs, line numbers, etc.
    statuscolumn = {
      enabled = true,
      left = { "mark", "sign" },
      right = { "fold", "git" },
      folds = { open = true, git_hl = true },
    },

    -- Word highlighting and jump
    words = { enabled = true },

    -- Zen mode
    zen = { enabled = true },

    -- Git utilities
    git = { enabled = true },
    gitbrowse = { enabled = true },
    lazygit = { enabled = true },

    -- Terminal (using toggleterm instead)
    -- terminal = { enabled = true },
  },
  keys = {
    { '<leader>e', function() Snacks.explorer() end, desc = 'File Explorer' },
    { '<leader>gg', function() Snacks.lazygit() end, desc = 'Lazygit' },
    { '<leader>gB', function() Snacks.gitbrowse() end, desc = 'Git browse' },
    { '<leader>un', function() Snacks.notifier.hide() end, desc = 'Dismiss notifications' },
    { '<leader>z', function() Snacks.zen() end, desc = 'Zen mode' },
    { ']]', function() Snacks.words.jump(1) end, desc = 'Next word reference', mode = { 'n', 'x', 'o' } },
    { '[[', function() Snacks.words.jump(-1) end, desc = 'Prev word reference', mode = { 'n', 'x', 'o' } },
    { '<leader>ul', function()
      -- Cycle: absolute → relative → off → absolute
      if not vim.wo.number and not vim.wo.relativenumber then
        vim.wo.number = true
        vim.wo.relativenumber = false
        Snacks.notify('Line numbers: absolute')
      elseif vim.wo.number and not vim.wo.relativenumber then
        vim.wo.number = true
        vim.wo.relativenumber = true
        Snacks.notify('Line numbers: relative')
      else
        vim.wo.number = false
        vim.wo.relativenumber = false
        Snacks.notify('Line numbers: off')
      end
    end, desc = 'Cycle line numbers' },
  },
}
