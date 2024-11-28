local M = {}

-- Default configuration
M.config = {
    commands = {
        nest = 'TsNest',
        unnest = 'TsUnnest'
    }
}

-- Setup function
function M.setup(opts)
    M.config = vim.tbl_deep_extend('force', M.config, opts or {})
    
    -- Register commands with custom names from config
    vim.api.nvim_create_user_command(M.config.commands.unnest, require('tsnest.operations').unnest, {})
    vim.api.nvim_create_user_command(M.config.commands.nest, require('tsnest.operations').nest, {})
end

return M
