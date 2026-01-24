return {
    'windwp/nvim-autopairs',
    event = "InsertEnter",
    opts = {
      check_ts = true,  -- Use treesitter to check for pairs
    },
}
