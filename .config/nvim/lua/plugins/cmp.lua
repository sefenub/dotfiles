return {
  'hrsh7th/nvim-cmp',
  event = 'InsertEnter',
  dependencies = {
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-buffer',
    'hrsh7th/cmp-path',
    'saadparwaiz1/cmp_luasnip',
    'windwp/nvim-autopairs',
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

    -- Track preselect state (persists via shada)
    if vim.g.PRESELECT_ON == nil then
      vim.g.PRESELECT_ON = 1
    end

    local function preselect_on()
      return vim.g.PRESELECT_ON == 1
    end

    -- Toggle function
    local function toggle_preselect()
      vim.g.PRESELECT_ON = preselect_on() and 0 or 1
      cmp.setup({
        preselect = preselect_on() and cmp.PreselectMode.Item or cmp.PreselectMode.None,
        completion = {
          completeopt = preselect_on() and 'menu,menuone,noinsert' or 'menu,menuone,noinsert,noselect',
        },
      })
      vim.notify('Preselect: ' .. (preselect_on() and 'ON' or 'OFF'))
    end

    vim.keymap.set('n', '<leader>uc', toggle_preselect, { desc = 'Toggle cmp preselect' })

    cmp.setup({
      snippet = {
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end,
      },
      preselect = preselect_on() and cmp.PreselectMode.Item or cmp.PreselectMode.None,
      completion = {
        completeopt = preselect_on() and 'menu,menuone,noinsert' or 'menu,menuone,noinsert,noselect',
      },
      mapping = cmp.mapping.preset.insert({
        ['<C-b>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.abort(),
        ['<CR>'] = cmp.mapping(function(fallback)
          if cmp.visible() then
            if not preselect_on() and not cmp.get_selected_entry() then
              fallback()
              return
            end
            if luasnip.expandable() then
              luasnip.expand()
            else
              cmp.confirm({ select = preselect_on() })
            end
          else
            fallback()
          end
        end),
        ['<Tab>'] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
          elseif luasnip.locally_jumpable(1) then
            luasnip.jump(1)
          else
            fallback()
          end
        end, { 'i', 's' }),
        ['<S-Tab>'] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          elseif luasnip.locally_jumpable(-1) then
            luasnip.jump(-1)
          else
            fallback()
          end
        end, { 'i', 's' }),
      }),
      sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        { name = 'luasnip' },
      }, {
        { name = 'buffer' },
        { name = 'path' },
      }),
    })

    -- Integrate autopairs with cmp
    local cmp_autopairs = require('nvim-autopairs.completion.cmp')
    cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done())
  end,
}
