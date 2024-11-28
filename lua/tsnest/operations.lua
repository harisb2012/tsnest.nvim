local api = vim.api
local fn = vim.fn

local M = {}

-- Helper function to check if directory has only one file
local function has_single_file(dir_path)
    local count = 0
    local single_file = nil
    
    for name in vim.fs.dir(dir_path) do
        -- Skip . and .. directories
        if name ~= "." and name ~= ".." then
            count = count + 1
            single_file = name
            -- If we find more than one file, return early
            if count > 1 then
                return false, nil
            end
        end
    end
    
    return count == 1, single_file
end

-- Helper function to refresh NvimTree
local function refresh_tree()
    -- Check if nvim-tree is loaded
    local nvim_tree_loaded, _ = pcall(require, 'nvim-tree')
    if nvim_tree_loaded then
        vim.cmd('NvimTreeRefresh')
    end
end

-- Helper function to get file path from NvimTree node
local function get_nvim_tree_file()
    local nvim_tree_loaded, nvim_tree_api = pcall(require, 'nvim-tree.api')
    if nvim_tree_loaded then
        local node = nvim_tree_api.tree.get_node_under_cursor()
        if node then
            return node.absolute_path
        end
    end
    return nil
end

-- Helper function to check if current window is NvimTree
local function is_in_tree()
    return vim.bo.filetype == 'NvimTree'
end

-- Helper function to handle buffer switching
local function handle_buffer_switch(old_file, new_file)
    local current_buf = api.nvim_get_current_buf()
    
    -- If we're in the tree
    if is_in_tree() then
        local affected_win = nil
        
        -- Find a window showing the affected file
        for _, win in ipairs(api.nvim_list_wins()) do
            local buf = api.nvim_win_get_buf(win)
            local buf_name = api.nvim_buf_get_name(buf)
            if buf_name:match(vim.pesc(old_file)) then
                affected_win = win
                break
            end
        end
        
        -- If we found a window with the affected file, switch its buffer
        if affected_win then
            local new_buf = vim.fn.bufadd(new_file)
            api.nvim_win_set_buf(affected_win, new_buf)
        end
        
        -- Clean up any other buffers with the old file
        for _, buf in ipairs(api.nvim_list_bufs()) do
            if api.nvim_buf_get_name(buf):match(vim.pesc(old_file)) then
                pcall(api.nvim_buf_delete, buf, { force = true })
            end
        end
    else
        -- If we're in a buffer, always switch to the new file
        vim.cmd('edit ' .. new_file)
    end
end

-- Command to unnest a folder with single index.ts(x) file
function M.unnest()
    -- Try to get file from NvimTree first, fallback to current buffer
    local current_file = get_nvim_tree_file() or fn.expand('%:p')
    local dir_path = fn.fnamemodify(current_file, ':h')
    local dir_name = fn.fnamemodify(dir_path, ':t')
    local extension = fn.fnamemodify(current_file, ':e')
    
    -- Check if current file is index.ts(x)
    if not current_file:match("index%.tsx?$") then
        print("Error: Current file is not index.ts(x)")
        return
    end
    
    -- Check if directory has only one file
    local is_single, single_file = has_single_file(dir_path)
    if not is_single then
        print("Error: Directory contains multiple files")
        return
    end
    
    -- Create new file path with properly separated extension
    local new_file = fn.fnamemodify(dir_path, ':h') .. '/' .. dir_name .. '.' .. extension
    
    -- Read current file content
    local file_content = fn.readfile(current_file)
    
    -- Write content to new file
    if fn.writefile(file_content, new_file) == 0 then
        -- Handle buffer switching
        handle_buffer_switch(current_file, new_file)
        
        -- Delete old file and directory using rm -rf to force deletion
        os.execute('rm -rf ' .. vim.fn.shellescape(dir_path))
        
        -- Refresh NvimTree
        refresh_tree()
    else
        print("Error: Could not create new file")
    end
end

-- Command to nest a .ts(x) file into a folder
function M.nest()
    -- Try to get file from NvimTree first, fallback to current buffer
    local current_file = get_nvim_tree_file() or fn.expand('%:p')
    local dir_name = fn.fnamemodify(current_file, ':t:r')
    local extension = fn.fnamemodify(current_file, ':e')
    
    -- Check if current file is a .ts(x) file
    if not current_file:match("%.tsx?$") then
        print("Error: Current file is not .ts(x)")
        return
    end
    
    -- Create new directory
    local new_dir = fn.fnamemodify(current_file, ':h') .. '/' .. dir_name
    fn.mkdir(new_dir, 'p')
    
    -- Create new file path with properly handled extension
    local new_file = new_dir .. '/index.' .. extension
    
    -- Read current file content
    local file_content = fn.readfile(current_file)
    
    -- Write content to new file
    if fn.writefile(file_content, new_file) == 0 then
        -- Handle buffer switching
        handle_buffer_switch(current_file, new_file)
        
        -- Delete old file
        os.remove(current_file)
        
        -- Refresh NvimTree
        refresh_tree()
    else
        print("Error: Could not create new file")
    end
end

return M
