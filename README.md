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
```lua
vim.keymap.set("n", "your_keymap_here", function()
	require("query-secretary").query_window_initiate()
end, {})
```

## Usage & Keybindings ⌨️

After putting your cursor where you want your query to end, press `your_keymap`
to bring up the Query Window.
<br>

Here are the default keymaps when you're in the Query Window (not customizable at the moment):
- `q` / `Esc` close the Query Window
-  `f` toggle current node's `field_name`
-  `p` / `P` toggle current node's `predicate`
- `d` remove current node's `predicate`

## Self Promotion

I'm looking to work for free (in a company 🏢 or team 👥) as a Front-End Developer 🖥️
<br>
**Contact me** at `ziontee113@gmail.com` 📧
