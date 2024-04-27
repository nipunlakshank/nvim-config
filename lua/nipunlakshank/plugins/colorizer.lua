return {
    "norcalli/nvim-colorizer.lua",
    event = "FileType",
    config = function()
        local defaults = {
            RGB = true, -- #RGB hex codes
            RRGGBB = true, -- #RRGGBB hex codes
            RRGGBBAA = true, -- #RRGGBBAA hex codes
            rgb_fn = true, -- CSS rgb() and rgba() functions
            hsl_fn = true, -- CSS hsl() and hsla() functions
            css = true, -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
            css_fn = true, -- Enable all CSS *functions*: rgb_fn, hsl_fn
            mode = "background", -- Set the display mode.
        }

        local opts = {
            'css',
            'html',
            'javascript',
            'typescript',
            'php',
        }

        require("colorizer").setup(opts, defaults)
    end,
}
