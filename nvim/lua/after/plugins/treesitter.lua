local languages = {
    'c_sharp',
    'comment',
    'css',
    'glimmer',
    'html',
    'javascript',
    'tsx',
    'typescript',
    'vimdoc'
}

require('nvim-treesitter.configs').setup({
    ensure_installed = languages,
    sync_install = false,
    auto_install = true,
    highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
    },
})
