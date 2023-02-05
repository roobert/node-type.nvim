# node-type.nvim

A NeoVIM plugin to show the currently selected node type from lsp and treesitter
information.

## Installation

### Lazy

```
{
    "roobert/node-type.nvim",
    config = function()
        require("node-type").setup()
    end,
}
```

### Packer

```
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

