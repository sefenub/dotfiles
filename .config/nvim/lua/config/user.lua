-- Personal configurations - edit freely
local M = {}

-- Custom keymaps
M.keymaps = function()
  local map = vim.keymap.set

  -- Quick command mode
  map("n", ";", ":")

  -- Quick escape
  map("i", "jk", "<Esc>")

  -- Keep visual selection after indent
  map("v", "<", "<gv")
  map("v", ">", ">gv")

  map("v", "<leader>/", "gc", { desc = "Toggle comment", remap = true })
  map("n", "<leader>/", "gcc", { desc = "Toggle comment", remap = true })

  -- Buffer commands
  map("n", "<leader>bd", "<cmd>bd<cr>", { desc = "Delete buffer" })
  map("n", "<leader>bn", "<cmd>bn<cr>", { desc = "Next buffer" })
  map("n", "<leader>bp", "<cmd>bp<cr>", { desc = "Previous buffer" })
  map("n", "<leader>bb", "<cmd>b#<cr>", { desc = "Alternate buffer" })
  map("n", "<leader>bl", "<cmd>ls<cr>", { desc = "List buffers" })

  -- Terminal toggle handled by toggleterm plugin
end

-- Custom options
M.options = function()
  -- Persist global variables
  vim.opt.shada:append('!')

  -- Prettier diagnostics
  vim.diagnostic.config({
    virtual_text = {
      prefix = '●',
      spacing = 2,
    },
    signs = {
      text = {
        [vim.diagnostic.severity.ERROR] = ' ',
        [vim.diagnostic.severity.WARN] = ' ',
        [vim.diagnostic.severity.INFO] = ' ',
        [vim.diagnostic.severity.HINT] = ' ',
      },
    },
    underline = true,
    update_in_insert = false,
    severity_sort = true,
    float = {
      border = 'rounded',
      source = true,
    },
  })

  vim.api.nvim_create_user_command('DiffOrig', function()
  local current_file = vim.api.nvim_buf_get_name(0)
  if current_file == "" then return end
    vim.cmd('vertical new')
    vim.cmd('read ++edit #')
    vim.cmd('normal! 1G"_d_') -- delete extra newline
    vim.cmd('diffthis')
    vim.cmd('wincmd p')
    vim.cmd('diffthis')
  end, {})
end

-- Custom autocommands
M.autocmds = function()
  -- Highlight on yank
  vim.api.nvim_create_autocmd('TextYankPost', {
    callback = function()
      vim.highlight.on_yank({ higroup = 'IncSearch', timeout = 150 })
    end,
  })

end

-- Run all
M.setup = function()
  M.options()
  M.keymaps()
  M.autocmds()
end

return M
