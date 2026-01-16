-- lua/plugins/lsp.lua

-- Copy diagnostic message to clipboard
local function copy_diagnostic()
  local line = vim.api.nvim_win_get_cursor(0)[1] - 1
  local diagnostics = vim.diagnostic.get(0, { lnum = line })
  if #diagnostics > 0 then
    local message = diagnostics[1].message
    if message then
      vim.fn.setreg("+", message)
      vim.notify("Diagnostic copied to clipboard", vim.log.levels.INFO)
    else
      vim.notify("No diagnostic message found", vim.log.levels.WARN)
    end
  else
    vim.notify("No diagnostics at cursor", vim.log.levels.WARN)
  end
end

return {
  'neovim/nvim-lspconfig',
  event = { 'BufReadPre', 'BufNewFile' },
  cmd = { 'Mason', 'LspInfo' },
  dependencies = {
    'williamboman/mason.nvim',
    'williamboman/mason-lspconfig.nvim',
    'hrsh7th/nvim-cmp',
  },
  config = function()
    local lspconfig = require('lspconfig')
    local capabilities = require('cmp_nvim_lsp').default_capabilities()

    require('mason').setup()
    require('mason-lspconfig').setup({
      ensure_installed = { 'lua_ls', 'pyright', 'ts_ls', 'rust_analyzer' },
      automatic_installation = true,
      handlers = {
        function(server_name)
          lspconfig[server_name].setup({
            capabilities = capabilities,
          })
        end,
      },
    })

    -- Use regular keymaps in LspAttach (which-key will auto-detect from desc)
    vim.api.nvim_create_autocmd('LspAttach', {
      callback = function(args)
        local opts = { buffer = args.buf }

        -- Go-to mappings (no leader)
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, vim.tbl_extend('force', opts, { desc = 'Go to definition' }))
        vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, vim.tbl_extend('force', opts, { desc = 'Go to declaration' }))
        vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, vim.tbl_extend('force', opts, { desc = 'Go to implementation' }))
        vim.keymap.set('n', 'gr', vim.lsp.buf.references, vim.tbl_extend('force', opts, { desc = 'References' }))
        vim.keymap.set('n', 'K', vim.lsp.buf.hover, vim.tbl_extend('force', opts, { desc = 'Hover documentation' }))

        -- Leader mappings
        vim.keymap.set('n', '<leader>cr', vim.lsp.buf.rename, vim.tbl_extend('force', opts, { desc = 'Rename' }))
        vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, vim.tbl_extend('force', opts, { desc = 'Code action' }))
        vim.keymap.set('n', '<leader>cf', vim.lsp.buf.format, vim.tbl_extend('force', opts, { desc = 'Format' }))

        -- Diagnostics
        vim.keymap.set('n', '<leader>cd', vim.diagnostic.open_float, vim.tbl_extend('force', opts, { desc = 'Show diagnostic' }))
        vim.keymap.set('n', '<leader>cc', function()
          vim.diagnostic.open_float(nil, { focus = false })
          vim.schedule(copy_diagnostic)
        end, vim.tbl_extend('force', opts, { desc = 'Copy diagnostic' }))
        vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, vim.tbl_extend('force', opts, { desc = 'Previous diagnostic' }))
        vim.keymap.set('n', ']d', vim.diagnostic.goto_next, vim.tbl_extend('force', opts, { desc = 'Next diagnostic' }))
      end,
    })
  end,
}
