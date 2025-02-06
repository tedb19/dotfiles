return {
  'stevearc/oil.nvim',
  dependencies = { { 'echasnovski/mini.icons', opts = {} } },
  config = function()
    require('oil').setup {
      columns = { 'icon' },
      keymaps = {
        ['<C-h>'] = false,
      },
      view_options = {
        show_hidden = true,
      },
    }
    -- Open parent directory in current window
    vim.keymap.set('n', '-', '<CMD>Oil<CR>', { desc = 'Open parent directory' })

    -- close oil window
    vim.keymap.set('n', 'q', '<CMD>:close<CR>', { desc = 'close oil window' })

    -- Open parent directry in floating window
    vim.keymap.set('n', '<space>-', require('oil').toggle_float, { desc = 'Open parent directory in floating window' })
  end,
}
