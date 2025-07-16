# Neovim Flake Plugin Additions

## New Plugins Added

### 1. **which-key.nvim**
- Shows available keybindings when you press a key and wait
- Helps discover commands you've configured but forgotten
- Press `<leader>` and wait to see all leader-based commands

### 2. **nvim-autopairs**
- Automatically closes brackets, quotes, and parentheses
- Smart handling based on context
- Use `<M-e>` (Alt+e) for fast wrap around words

### 3. **gitsigns.nvim**
- Shows git changes in the sign column (left gutter)
- Inline git blame and hunk management
- Key bindings:
  - `]c` / `[c` - Navigate between git changes
  - `<leader>hs` - Stage current hunk
  - `<leader>hr` - Reset current hunk
  - `<leader>hp` - Preview hunk changes
  - `<leader>hb` - Show blame for current line
  - `<leader>tb` - Toggle inline blame

### 4. **lsp-signature.nvim**
- Shows function signatures and parameter hints while typing
- Automatically appears when you type `(` after a function name
- Use `<M-x>` to manually toggle signature help

## Function Parameter Help Configuration

The function signature help now works through multiple mechanisms:

1. **Automatic Signature Display**:
   - When you type a function name followed by `(`, a floating window will show:
     - Function signature
     - Parameter types
     - Current parameter highlighted
     - Documentation if available

2. **nvim-cmp Integration**:
   - Added `nvim_lsp_signature_help` source to cmp
   - Shows signatures in the completion menu
   - Navigate docs with `<C-f>` (forward) and `<C-b>` (backward)

3. **Example Usage**:
   ```typescript
   // When you type:
   myFunction(
   
   // You'll see:
   // myFunction(param1: string, param2: number, options?: Options)
   // ^^^^^^^^^ (current parameter highlighted)
   ```

## Fixed Issues

1. **Duplicate Keybinding**: Changed LSP format from `<leader>f` to `<leader>lf` to avoid conflict with NvimTree
2. **LSP Format Syntax**: Fixed the syntax error in the format keybinding
3. **Enhanced nvim-cmp**: Added better window borders, ghost text, and documentation scrolling

## Tips for Using Function Signatures

1. The signature help appears automatically when typing `(`
2. Use `<C-Space>` to manually trigger completion with signatures
3. The hint prefix "🐦" indicates signature help is active
4. Signatures update as you move between parameters with `,`
5. Use `<M-x>` to toggle signature window if it gets in the way

## Testing Your Configuration

After rebuilding your flake, test the function signatures by:

1. Opening a file with LSP support (e.g., `.ts`, `.py`, `.go`)
2. Start typing a known function and add `(`
3. You should see the signature popup
4. Navigate parameters with `,` to see highlighting change

Remember to rebuild your flake:
```bash
nix build
./result/bin/nvim
```

Or if you're using it as an overlay:
```bash
nix develop
nvim
```