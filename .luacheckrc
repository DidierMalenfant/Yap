-- Globals provided by Yap!
stds.yap = {
    globals = {
        Main = {
            fields = {
                super = {
                    fields = {
                        className = {},
                        init = {},
                    }
                },
                className = {},
                init = {},
            }
        }
    }
}

require "toyboxes/luacheck" (stds, files)

std = "lua54+playdate+yap+toyboxes"

operators = {"+=", "-=", "*=", "/="}
