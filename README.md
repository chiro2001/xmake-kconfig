# xmake-kconfig

Kconfig loader and parser for xmake.

## Dependences

- python3
- kconfiglib: `python3 -m pip install kconfiglib`
- (if windows) windows-curses: `python3 -m pip install windows-curses`

## Install

In `plugins` directory:

```shell
git clone https://github.com/chiro2001/xmake-kconfig
```

## Usage

Plugins: `menuconfig`, `genconfig`, `cleanconfig`

example `xmake.lua`:

```lua
add_rules("mode.debug", "mode.release")

target("hello")
    set_kind("binary")
    add_files("src/*.c")
    add_plugindirs(path.join(os.projectdir(), "plugins"))
    on_clean(function () 
        import("core.base.task")
        task.run("menuclean")
    end)
    on_load(function (target)
        cprint("${bright yellow} -- on_load()")
        import("kconfig", { rootdir = path.join(os.projectdir(), "plugins/xmake-kconfig")})
        local kc = kconfig.load()
        print(kc)
        print(format("CONFIG_X_STR = %s", kc["CONFIG_X_STR"]))
    end)
    before_build(function (target)
        cprint("${bright yellow} -- before_load()")
        import("kconfig", { rootdir = path.join(os.projectdir(), "plugins/xmake-kconfig")})
        kconfig.load()
    end)
```