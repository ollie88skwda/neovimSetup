-- init.lua

require "core"

local custom_init_path = vim.api.nvim_get_runtime_file("lua/custom/init.lua", false)[1]

if custom_init_path then
  dofile(custom_init_path)
end

require("core.utils").load_mappings()

local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"

-- bootstrap lazy.nvim!
if not vim.loop.fs_stat(lazypath) then
  require("core.bootstrap").gen_chadrc_template()
  require("core.bootstrap").lazy(lazypath)
end

dofile(vim.g.base46_cache .. "defaults")
vim.opt.rtp:prepend(lazypath)
require "plugins"

-- Function to run the current file in a new external terminal window
_G.run_in_terminal = function()
    local current_file = vim.fn.expand('%:p')  -- Get the full path of the current file

    -- Check if the buffer is modified
    if vim.bo.modified then
        -- Save the buffer
        vim.cmd("w")
    end

    -- Open a new PowerShell window and run the compilation and execution commands
    vim.fn.system('start powershell -NoExit -Command "& { Start-Process cmd -ArgumentList \'/k g++ "' .. current_file .. '" -o "' .. vim.fn.expand('%:p:h') .. '/a.exe" && "' .. vim.fn.expand('%:p:h') .. '/a.exe"\'; exit }"')
end

-- Define the custom command
vim.cmd([[command! -nargs=0 RunInTerminal lua run_in_terminal()]])

-- Map <leader>cd to the custom command
vim.api.nvim_set_keymap('n', '<leader>cd', ':RunInTerminal<CR>', { noremap = true, silent = true })

