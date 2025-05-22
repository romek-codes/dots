# Nixvim is a NixOS module that installs and configures Neovim
{ inputs, ... }: {
  # TODO: Add toggle comment keybind
  imports = [
    inputs.nixvim.homeManagerModules.nixvim
    ./plugins/cmp.nix
    ./plugins/floaterm.nix
    ./plugins/git.nix
    ./plugins/lsp.nix
    ./plugins/markdown.nix
    ./plugins/mini.nix
    ./plugins/picker.nix
    ./plugins/snacks.nix
    ./plugins/trouble.nix
    ./plugins/utils.nix
    ./plugins/obsidian.nix
    ./plugins/noice.nix
    ./plugins/highlight-colors.nix

    ./options.nix
    ./keymaps.nix
    ./autocmds.nix
  ];

  programs.nixvim.enable = true;
}
