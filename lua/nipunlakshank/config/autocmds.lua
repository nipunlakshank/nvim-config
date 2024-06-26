local vim_enter_group = vim.api.nvim_create_augroup("VimEnterGroup", {})
-- local lsp_fmt_group = vim.api.nvim_create_augroup("LspFormattingGroup", {})
-- local lsp_attach_group = vim.api.nvim_create_augroup("LspAttachGroup", {})
local highlight_yank_group = vim.api.nvim_create_augroup("HighlightYankGroup", {})
local python_env_group = vim.api.nvim_create_augroup("PythonEnvGroup", {})
local colorscheme_group = vim.api.nvim_create_augroup("ColorSchemeGroup", {})
local syntax_group = vim.api.nvim_create_augroup("SyntaxGroup", {})

vim.api.nvim_create_autocmd("BufEnter", {
    group = syntax_group,
    pattern = "*",
    callback = function()
        -- vim.bo.syntax = "on"
    end,
})

vim.api.nvim_create_autocmd("VimEnter", {
    group = vim_enter_group,
    callback = function()
        vim.cmd.colorscheme(_G.colorscheme) -- Set colorscheme
    end,
})

-- auto-format on save
-- vim.api.nvim_create_autocmd("BufWritePre", {
--     group = lsp_fmt_group,
--     callback = function()
--         local efm = vim.lsp.get_active_clients({ name = "efm" })
--
--         if vim.tbl_isempty(efm) then
--             return
--         end
--
--         vim.lsp.buf.format({ name = "efm", async = true })
--     end,
-- })

-- highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
    group = highlight_yank_group,
    callback = function()
        vim.highlight.on_yank()
    end,
})

vim.api.nvim_create_autocmd({ "BufEnter" }, {
    group = syntax_group,
    pattern = { ".env*" },
    callback = function()
        local buf_name = vim.api.nvim_buf_get_name(0)
        if string.endswith(buf_name, ".example") then
            vim.cmd("set filetype=conf")
            return
        end
        vim.cmd("set filetype=config")
    end,
})

vim.api.nvim_create_autocmd({ "UIEnter", "ColorScheme" }, {
    group = colorscheme_group,
    callback = function()
        local colorscheme = vim.g.colors_name
        local keymap = "<leader>tt"
        -- local themes = require("nipunlakshank.plugins.themes")

        if string.match(colorscheme, "catppuccin") ~= -1 then
            vim.keymap.set("n", keymap, function()
                local catppuccin = require("catppuccin")
                local opts = catppuccin.options or {}
                opts.transparent_background = not opts.transparent_background
                catppuccin.setup(opts)
                vim.cmd.colorscheme(vim.g.colors_name)
            end, { noremap = false, silent = true, desc = "Toggle transparency (" .. colorscheme .. ")" })
            return
        end
    end,
})

vim.api.nvim_create_autocmd({ "VimEnter" }, {
    group = python_env_group,
    callback = function()
        vim.schedule(function()
            local f = require("nipunlakshank.utils.functions")
            local python_env_path = vim.fn.stdpath("data") .. "/python"

            if f.os.is_windows then
                f.async_cmd(
                    "python -m venv "
                    .. python_env_path
                    .. ";  "
                    .. python_env_path
                    .. "/Scripts/activate && pip install --upgrade pip && pip install neovim; deactivate"
                )
                vim.g.python3_host_prog = python_env_path .. "/Scripts/python"
            else
                f.async_cmd(
                    "mkdir -p "
                    .. python_env_path
                    .. " && python3 -m venv "
                    .. python_env_path
                    .. " && source "
                    .. python_env_path
                    .. "/bin/activate && pip install --upgrade pip && pip install neovim && deactivate"
                )
                vim.g.python3_host_prog = python_env_path .. "/bin/python3"
            end
        end)
    end,
})
