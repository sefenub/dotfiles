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
    {
      "benomahony/uv.nvim",
      opts = {
        picker_integration = true,
      },
    },
    {
      'stevearc/conform.nvim',
      opts = {
        formatters_by_ft = {
          python = { 'black' },
          sql = { "sqlfluff" },
          cpp = { 'clang_format' },
          c = { 'clang_format' },
          go = { 'goimports', 'gofumpt' },
          javascript = { 'prettier' },
          typescript = { 'prettier' },
          javascriptreact = { 'prettier' },
          typescriptreact = { 'prettier' },
          json = { 'prettier' },
          html = { 'prettier' },
          css = { 'prettier' },
        },
        formatters = {
          sqlfluff = {
            command = "sqlfluff",
            args = { "format", "--dialect", "oracle", "--disable-progress-bar", "-" },
            stdin = true,
          },
        },
      },
      keys = {
        { '<leader>cf', function() require('conform').format({ async = true }) end, desc = 'Format' },
      },
    },
    {
    'neovim/nvim-lspconfig',
    lazy = false,
    cmd = { 'Mason', 'LspInfo' },
    dependencies = {
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',
      'hrsh7th/nvim-cmp',
      'WhoIsSethDaniel/mason-tool-installer.nvim'
    },
    config = function()
      local lspconfig = require('lspconfig')
      local capabilities = require('cmp_nvim_lsp').default_capabilities()

      require('mason').setup()
      require('mason-tool-installer').setup({
        ensure_installed = { 'autopep8', 'clang-format', 'goimports', 'gofumpt', 'prettier', 'tflint' }
      })
      require('mason-lspconfig').setup({
        ensure_installed = {
          'lua_ls',
          'pyright',
          'ts_ls',
          'rust_analyzer',
          'clangd',
          'gopls',
          'terraformls'
        },
        automatic_installation = true,
        handlers = {
          function(server_name)
            lspconfig[server_name].setup({
              capabilities = capabilities,
            })
          end,
        },
      })

      -- Use regular keymaps in LspAttach
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
}
