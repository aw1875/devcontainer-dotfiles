local ok, lsp = pcall(require, 'lspconfig')
if not ok then
    require('notify')('LSP failed to load', 'error')
    return
end

-- LSP Config
local capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())

-- Create on attach keymaps
local map = require('utils').map
local on_attach = function()
    map('n', 'K', vim.lsp.buf.hover, { buffer = 0 })
    map('n', 'gd', vim.lsp.buf.definition, { buffer = 0 })
    map('n', 'gT', vim.lsp.buf.type_definition, { buffer = 0 })
    map('n', 'gi', vim.lsp.buf.implementation, { buffer = 0 })
    map('n', 'gr', '<cmd>TroubleToggle lsp_references<cr>', { buffer = 0 })
    map('n', '<leader>dn', vim.diagnostic.goto_next, { buffer = 0 })
    map('n', '<leader>dp', vim.diagnostic.goto_prev, { buffer = 0 })
    map('n', '<leader>rn', vim.lsp.buf.rename, { buffer = 0 })
    map('n', '<leader>ca', vim.lsp.buf.code_action, { buffer = 0 })
end

-- Diagnostics Settings
local signs = {
    Error = ' ',
    Warn = ' ',
    Hint = ' ',
    Info = ' ',
}

for type, icon in pairs(signs) do
    local hl = 'DiagnosticSign' .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

vim.opt.spelllang = { 'en_us' }

vim.diagnostic.config({
    virtual_text = false,
    signs = true,
    underline = true,
    update_in_insert = false,
    severity_sort = true,
    float = {
        show_header = false,
        source = true,
        border = 'rounded',
        focusable = true,
    },
})

-- Custom Settings
local customSettings = {
    tailwindcss = {
        tailwindCSS = {
            includeLanguages = {
                markdown = 'html',
                handlebars = 'html',
                javascript = {
                    glimmer = 'javascript'
                },
                typescript = {
                    glimmer = 'javascript'
                }
            },
            classAttributes = { 'class', 'className', 'classList', 'ngClass' },
            lint = {
                cssConflict = 'warning',
                invalidApply = 'error',
                invalidConfigPath = 'error',
                invalidScreen = 'error',
                invalidTailwindDirective = 'error',
                invalidVariant = 'error',
                recommendedVariantOrder = 'warning'
            },
            validate = true
        }
    },
    tsserver = {
        maxTsServerMemory = 8000,
        implicitProjectConfig = {
            experimentalDecorators = true
        },
    },
    cssls = {
        css = {
            validate = true,
            lint = {
                unknownAtRules = 'ignore'
            },
        },
    },
    omnisharp = {
        cmd = { 'dotnet', vim.fn.expand("~") .. '/.local/share/nvim/mason/packages/omnisharp/libexec/OmniSharp.dll' },
        enable_editorconfig_support = true,
        enable_ms_build_load_projects_on_demand = true,

        enable_rosyln_analyzers = true,
        organize_imports_timeout = false,
        enable_import_completion = true,
        sdk_include_previews = true,

        analyze_open_documents_only = false,
    }
}

local servers = {
    -- Languages
    'html',
    'cssls',
    'tsserver',
    'jsonls',
    'omnisharp',

    -- Frameworks
    'ember',
    'glint',

    -- Tools
    'tailwindcss',
}

-- Setup Mason
require('mason').setup({
    ui = {
        icons = {
            server_installed = '✓',
            server_pending = '➜',
            server_uninstalled = '✗'
        }
    }
})
require('mason-lspconfig').setup({
    ensure_installed = servers,
    automatic_installation = false
})

-- Setup LSP
for _, serverName in ipairs(servers) do
    local server = lsp[serverName]

    if server then
        if serverName == 'glint' then
            server.setup({
                on_attach = on_attach,
                capabilities = capabilities,
                settings = customSettings[serverName],
            })
        elseif serverName == 'omnisharp' then
            server.setup({
                on_attach = function(client)
                    client.server_capabilities.semanticTokensProvider = nil
                    on_attach()
                end,
                capabilities = capabilities,
                settings = customSettings[serverName],
            })
        else
            server.setup({
                on_attach = on_attach,
                capabilities = capabilities,
                settings = customSettings[serverName],
                single_file_support = true,
            })
        end
    end
end
