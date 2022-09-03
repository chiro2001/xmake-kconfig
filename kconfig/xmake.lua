option("python")
    set_default("python3")
    set_showmenu(true)

option("config_file")
    set_default(".config")
    set_showmenu(true)

option("config_head")
    set_default("include/generated/autoconf.h")
    set_showmenu(true)

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
        os.exec("python3 -m genconfig --config-out .config --header-path build/include/generated/autoconf.h")
    end)
    set_menu {
                usage = "xmake genconfig",
                description = "Generate .config and autoconfig.h",
                options = {}
            }