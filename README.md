# node-type.nvim [WIP]

![node-type screenshot](https://user-images.githubusercontent.com/226654/216843214-50cace9a-a6dc-4654-aa36-bffc4aba1856.gif)

A NeoVIM plugin to show the currently selected node type from lsp and treesitter
information.

## Installation

### Lazy

``` lua
{
    "roobert/node-type.nvim",
    config = function()
        require("node-type").setup()
    end,
}
```

### Packer

``` lua
use({
    "roobert/node-type.nvim",
    config = function()
        require("node-type").setup()
    end,
})
```

## Usage

It's possible to use this plugin either via a key-binding, the function interface, or as
a statusline component.

The default binding is `<leader>n`.

As a lualine statusline component:

```
require('lualine').setup {
  sections = {
      lualine_x = { require("node-type").statusline }
  }
}
```

