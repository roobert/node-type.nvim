# :globe_with_meridians: node-type.nvim

![node-type screenshot](https://user-images.githubusercontent.com/226654/216843214-50cace9a-a6dc-4654-aa36-bffc4aba1856.gif)

A NeoVIM plugin to show the currently selected node type from lsp and treesitter
information.

The demo shows this plugin being used in several ways:
* using the lualine statusline integration to show the node-type info in the statusline
* via a key-binding
* via a call to the plugin api

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

The default binding is `<leader>n`.

As a lualine statusline component:

``` lua
require('lualine').setup {
  sections = {
      lualine_x = { require("node-type").statusline }
  }
}
```

Via the API:

``` lua
require("node-type").get()
```

