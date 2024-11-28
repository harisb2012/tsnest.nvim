# tsnest.nvim

🪺 Lightning-fast TypeScript/React component restructuring for Neovim - seamlessly nest and unnest your components with a single command.

## Features

- 📁 Nest components into folder structures (`Component.tsx` → `Component/index.tsx`)
- 📄 Unnest folder components into files (`Component/index.tsx` → `Component.tsx`)
- 🌳 Seamless NvimTree integration
- ⚡ Zero configuration needed
- 🛡️ Safe operations with validation checks
- 🧠 Smart buffer handling

## Installation

### Using [vim-plug](https://github.com/junegunn/vim-plug)

```vim
Plug 'nvim-tree/nvim-tree.lua' " Required dependency
Plug 'harisb2012/tsnest.nvim'
```

### Using [packer.nvim](https://github.com/wbthomason/packer.nvim)

```lua
use {
  'harisb2012/tsnest.nvim',
  requires = {
    'nvim-tree/nvim-tree.lua'
  }
}
```

### Using [lazy.nvim](https://github.com/folke/lazy.nvim)

```lua
{
  'harisb2012/tsnest.nvim',
  dependencies = {
    'nvim-tree/nvim-tree.lua'
  }
}
```

## Setup

```lua
require('tsnest').setup({
  -- Optional configuration (shown with defaults)
  commands = {
    nest = 'TsNest',     -- Command to nest file into folder
    unnest = 'TsUnnest'  -- Command to unnest folder into file
  },
  -- Coming soon:
  -- auto_format = true,     -- Format file after transformation
  -- notify = true,          -- Show notifications
  -- patterns = {            -- Custom file patterns
  --   index = "index",      -- Default index file name
  --   extensions = {"ts", "tsx"} -- Supported file extensions
  -- }
})
```

## Usage

1. **Nesting a component into a folder**
   - Open a `.ts`/`.tsx` file or hover over it in NvimTree
   - Run `:TsNest`
   - `Button.tsx` becomes `Button/index.tsx`

2. **Unnesting a folder component into a file**
   - Open an `index.ts`/`index.tsx` file or hover over it in NvimTree
   - Run `:TsUnnest`
   - `Button/index.tsx` becomes `Button.tsx`

Both commands work seamlessly:
- From the buffer with the file open
- From NvimTree with cursor over the file

## Why tsnest.nvim?

Modern React/TypeScript projects often require restructuring components as they evolve - adding styles, tests, or sub-components means converting a single file into a folder structure. This usually involves multiple manual steps: creating directories, moving files, renaming, and updating imports. tsnest.nvim makes this instantaneous and foolproof.

## Coming Soon

- [ ] Auto-formatting after transformation
- [ ] Custom patterns support
- [ ] Multi-file folder support
- [ ] Undo/redo stack
- [ ] LSP workspace refresh
- [ ] Integration with other file explorers

## Contributing

Contributions welcome! Feel free to submit issues and pull requests.

## License

MIT
