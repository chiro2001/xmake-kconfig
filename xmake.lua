includes("options.lua")

task("menuclean")
    set_category("plugin")
    on_run(function ()
        import("kconfig")
        kconfig.clean()
    end)

task("menuconfig")
    set_category("plugin")
    on_run(function ()
        os.exec("python3 -m menuconfig")
    end)
    set_menu {
                usage = "xmake menuconfig",
                description = "Show menuconfig for Kconfig",
                options = {}
            }

task("genconfig")
    set_category("plugin")
    on_run(function ()
        local config_dir = os.projectdir() .. "/build"
        if not os.exists(config_dir) then os.mkdir(config_dir) end
        local exec = "python3 -m genconfig --config-out .config --header-path " .. os.projectdir() .. "/build/autoconf.h"
        cprint("${bright}%s", exec)
        os.exec(exec)
    end)
    set_menu {
                usage = "xmake genconfig",
                description = "Generate .config and autoconf.h",
                options = {}
            }