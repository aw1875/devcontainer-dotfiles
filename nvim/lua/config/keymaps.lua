-------------------------------------
-- General Bindings
-------------------------------------
local map = require('utils').map

-- Open File
map('n', 'gf', '<cmd>e <cfile><CR>')

-- Source File
map('n', '<A-x>', '<cmd>so %<CR>')

-- Move Live
map('n', '<A-k>', ':m-2<CR>')
map('n', '<A-j>', ':m+<CR>')
map('i', '<A-k>', '<Esc>:m-2<CR> i')
map('i', '<A-j>', '<Esc>:m+<CR> i')
map('v', '<A-k>', ':m \'<-2<CR>gv=gv')
map('v', '<A-j>', ':m \'>+<CR>gv=gv')

-- Duplicate Line
map('n', '<A-S-Up>', 'yy <cmd>pu!<CR>')
map('i', '<A-S-Up>', '<Esc>yy <cmd>pu!<CR>')
map('v', '<A-S-Up>', 'y <cmd>pu!<CR>')
map('n', '<A-S-Down>', 'yy <cmd>pu<CR>')
map('i', '<A-S-Down>', '<Esc>yy <cmd>pu<CR>')
map('v', '<A-S-Down>', 'y <cmd>\'<,\'>pu<CR>')

-- JSON Formatting
map('n', '<leader>jp', '<cmd>.!jq .<CR>')
map('v', '<leader>jm', '<cmd>%!jq -c<CR>')

-- Switching Tabs
map('n', '<Tab>', '<cmd>bn<CR>')
map('n', '<S-Tab>', '<cmd>bp<CR>')
map('n', '<C-q>', '<cmd>bw<CR>')

-- NVIM Tree Bindings
map('n', '<leader>t', '<cmd>Neotree toggle<CR>')
map('n', '<leader>nf', '<cmd>Neotree focus<CR>')

-- Git
local gs = require('gitsigns')
map('n', '<leader>gs', vim.cmd.Git)
map('n', '<leader>gb', function()
    gs.blame_line { full = true }
end)
map({ 'n', 'v' }, '<leader>hs', function()
    if vim.fn.mode == 'v' then
        gs.stage_hunk { vim.fn.line('.'), vim.fn.line('v') }
    else
        gs.stage_hunk()
    end
end)
map({ 'n', 'v' }, '<leader>hr', function()
    if vim.fn.mode == 'v' then
        gs.reset_hunk { vim.fn.line('.'), vim.fn.line('v') }
    else
        gs.reset_hunk()
    end
end)
map({ 'n', 'v' }, '<leader>hu', function()
    if vim.fn.mode == 'v' then
        gs.undo_stage_hunk { vim.fn.line('.'), vim.fn.line('v') }
    else
        gs.undo_stage_hunk()
    end
end)

-- Git Navigating
map('n', ']c', function()
    if vim.wo.diff then return ']c' end
    vim.schedule(function()
        gs.next_hunk()
    end)
    return '<Ignore>'
end, { expr = true })

map('n', '[c', function()
    if vim.wo.diff then return '[c' end
    vim.schedule(function()
        gs.prev_hunk()
    end)
    return '<Ignore>'
end, { expr = true })

-- DevContainers
vim.api.nvim_create_user_command("DevContainers", function(opts)
    local args = opts.args
    if args == "CloseContainer" then
        vim.cmd("qa!")
    end
end, {
    nargs = 1,
    complete = function()
        return { "CloseContainer" }
    end
})
map('n', '<C-x>x', ":DevContainers CloseContainer<CR>")

return {
    map = map,
}
