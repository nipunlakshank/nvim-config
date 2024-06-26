local build
if vim.fn.has("win32") == 1 then
    build = vim.fn.stdpath("data") .. "/python/Scripts/activate; " .. "pip install hererocks && python -mhererocks . -j2.1.0-beta3 -r3.0.0 && cp nvim_rocks.lua lua"
else
    build = "source ".. vim.fn.stdpath("data") .. "/python/bin/activate && " .. "pip install hererocks && python3 -mhererocks . -j2.1.0-beta3 -r3.0.0 && cp nvim_rocks.lua lua"
end

return {
    {
        "theHamsta/nvim_rocks",
        event = "VeryLazy",
        build = build,
        config = function()
            local nvim_rocks = require("nvim_rocks")
            -- Install the magick rock
            nvim_rocks.ensure_installed("magick")
        end,
    },
}
