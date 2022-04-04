# markdown-map.nvim

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

## Highlights

Colors on the heading levels use `markdownH<level>` highlight groups, so you can specify colors that go from green (H1) to purple (H6) using something like

```vim
hi markdownH1	guifg=#84ff41
hi markdownH2	guifg=#57ff7e
hi markdownH3	guifg=#40ffd9
hi markdownH4	guifg=#60adff
hi markdownH5	guifg=#6753ff
hi markdownH6	guifg=#a333ff
```
