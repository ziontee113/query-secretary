## 📓 Query Secretary 🖊️
#### Neovim Plugin that *assists* you in writing Treesitter Queries 🌳
#### This plugin exists because *we don't want to manually write them queries ourselves* 🤓

![query-secretary](https://user-images.githubusercontent.com/102876811/198027185-0af9abff-830d-464b-8016-bc7a5474b756.png)

## Demo 🎥

https://user-images.githubusercontent.com/102876811/198029879-dbb552de-05f5-41c0-baa4-eca3d718db98.mp4

## Developer's Message ✉️
This plugin is still in *Prototype Phase!* With features hasn't been developed yet!
Such as:
- End-user customizations (window location, highlight groups, etc...)
- Add / Manage **Children** and **Siblings** nodes
<br>

At this current state, this plugin is **useful** for ***simple queries that doesn't deal with
multi-layered children / sibling nodes***. These features will be gradually developed as
the demand of more complex queries increases.
<br>

## Installation 💽
Packer:
```lua
use("ziontee113/query-secretary")
```

## Setup 💻
By default, Query Window at the center of the editor.
<br>
If you want to change how the query window options:
<br>
```lua
require('query-secretary').setup({
    open_win_opts = {
        row = 0,
        col = 9999,
        width = 50,
        height = 15,
    },

    -- other options you can customize
    buf_set_opts = {
        tabstop = 2,
        softtabstop = 2,
        shiftwidth = 2,
    }

    capture_group_names = { "cap", "second", "third" } -- when press "c"
    predicates = { "eq", "any-of", "contains", "match", "lua-match" } -- when press "p"
    visual_hl_group = "Visual" -- when moving cursor around

    -- here are the default keymaps
    keymaps = {
        close = { "q", "Esc" },
        next_predicate = { "p" },
        previous_predicate = { "P" },
        remove_predicate = { "d" },
        toggle_field_name = { "f" },
        yank_query = { "y" },
        next_capture_group = { "c" },
        previous_capture_group = { "C" },
    }
})
```
<br>

The following `setup` will open Query Window at your cursor
with `width = 50` and `height = 15`
```lua
require('query-secretary').setup({
    open_win_opts = {
        relative = "cursor",
        width = 50,
        height = 15,
    },
})
```

Define your keymap:
```lua
vim.keymap.set("n", "your_keymap_here", function()
    require("query-secretary").query_window_initiate()
end, {})
```

## Usage & Keybindings ⌨️

After putting your cursor where you want your query to end, press `your_keymap`
to bring up the Query Window.
<br>

Here are the default keymaps when you're in the Query Window (customizable with setup function):
- `q` / `Esc` close the Query Window
-  `f` toggle current node's `field_name`
-  `p` / `P` toggle current node's `predicate`
- `d` remove current node's `predicate`
