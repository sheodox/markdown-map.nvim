# mardown-map.nvim

Navigate to headings in a markdown file with a popup table of contents.

https://user-images.githubusercontent.com/3468630/161474498-71af19c4-cbed-4eae-9ff2-efdb13c5a534.mp4

## Install

Use your favorite plugin manager to install (requires plenary)

```vim
call dein#add('nvim-lua/plenary.nvim')
call dein#add('sheodox/markdown-map.nvim')
```

## Configuration

```lua
vim.keymap.set('n', "<leader>md", require('markdownmap').toggle_map_menu, {noremap = true, expr = false, buffer = false})
```

Pressing `<CR>` on a row in the popup menu will move your cursor to that line.
