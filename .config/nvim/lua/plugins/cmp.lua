return {
  'hrsh7th/nvim-cmp',
  event = 'InsertEnter',
  dependencies = {
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-buffer',
    'hrsh7th/cmp-path',
    'saadparwaiz1/cmp_luasnip',
    {
      'L3MON4D3/LuaSnip',
      version = 'v2.*',
      build = 'make install_jsregexp',
      dependencies = { 'rafamadriz/friendly-snippets' },
      config = function()
        require('luasnip.loaders.from_vscode').lazy_load()
      end,
    },
  },
  config = function()
    local cmp = require('cmp')
    local luasnip = require('luasnip')

    -- Endwise helper for Lua
    local function endwise_cr()
      local line = vim.api.nvim_get_current_line()
      local ft = vim.bo.filetype
      if ft == 'lua' and (
        line:match('function.*%)%s*$') or
        line:match('if.+then%s*$') or
        line:match('for.+do%s*$') or
        line:match('while.+do%s*$')
      ) then
        local indent = line:match('^(%s*)')
        return '<CR>' .. indent .. 'end<C-o>O'
      end
      return '<CR>'
    end

    cmp.setup({
      snippet = {
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end,
      },
      mapping = cmp.mapping.preset.insert({
        ['<C-b>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.abort(),
        ['<CR>'] = function(fallback)
          if cmp.visible() then
            cmp.confirm({ select = true })
          else
            local keys = vim.api.nvim_replace_termcodes(endwise_cr(), true, true, true)
            vim.api.nvim_feedkeys(keys, 'n', false)
          end
        end,
        ['<Tab>'] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
          elseif luasnip.expand_or_jumpable() then
            luasnip.expand_or_jump()
          else
            fallback()
          end
        end, { 'i', 's' }),
        ['<S-Tab>'] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          elseif luasnip.jumpable(-1) then
            luasnip.jump(-1)
          else
            fallback()
          end
        end, { 'i', 's' }),
      }),
      sources = cmp.config.sources({
        { name = 'luasnip' },
        { name = 'nvim_lsp' },
        { name = 'buffer' },
        { name = 'path' },
      }),
    })
  end,
}
