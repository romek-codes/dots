{
  programs.nixvim = {
    plugins = {
      gitsigns.enable = true;
      snacks.settings = { lazygit.enable = true; };
    };
    keymaps = [{
      key = "<leader>gg";
      action = "<cmd>lua Snacks.lazygit()<cr>";
      options.desc = "LazyGit";
    }];
  };
}
