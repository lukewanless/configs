-- Utilities for creating configurations
-- local util = require('formatter.util')
local filetypes = {}
local defaults = require('formatter.filetypes')
for k, v in pairs(defaults) do
  filetypes[k] = {}
  for _, vv in pairs(v) do
    local config = vv()
    if vim.fn.executable(config['exe']) == 1 then
      table.insert(filetypes[k], config)
    end
  end
end

filetypes['lua'] = { {exe="stylua"} }
filetypes['yaml'] = {defaults['yaml']['prettier']()} -- Provides the Format, FormatWrite, FormatLock, and FormatWriteLock commands
require('formatter').setup({
  -- Enable or disable logging
  logging = true,
  -- Set the log level
  log_level = vim.log.levels.WARN,
  -- All formatter configurations are opt-in so opt into them all :P
  filetype = filetypes,
}) vim.keymap.set('n', '<F1>', ':FormatWrite<CR>')


