{ config, lib, ... }: {
  programs.nixvim = {
    plugins.obsidian = {
      enable = true;

      # Define workspaces that will be checked - NixVim will use the first one that exists
      settings = {
        workspaces = [
          # meshify computer
          # TODO: Make this dynamic, otherwise error gets thrown when one of these is not found.
          #{
          #  name = "personal";
          #  path = "/mnt/hdd-1tb/notes/personal";
          #}
          #{
          #  name = "work";
          #  path = "/mnt/hdd-1tb/notes/work";
          #}
          # lenovo-yoga computer
          {
            name = "personal";
            path = "/home/romek/notes/personal";
          }
          {
            name = "work";
            path = "/home/romek/notes/work";
          }
        ];

        # Disable the UI components
        ui.enable = false;
      };
    };

    # Convert your keybindings to NixVim format
    keymaps = [
      {
        key = "<Leader>os";
        action = "<cmd>ObsidianSearch<cr>";
        options.desc = "Search";
      }
      {
        key = "<Leader>oo";
        action = "<cmd>ObsidianOpen<cr>";
        options.desc = "Open";
      }
      {
        key = "<Leader>ot";
        action = "<cmd>ObsidianTags<cr>";
        options.desc = "Tags";
      }
      {
        key = "<Leader>on";
        action = "<cmd>ObsidianNew<cr>";
        options.desc = "New note";
      }
      {
        key = "<Leader>og";
        action = "<cmd>ObsidianFollowLink<cr>";
        options.desc = "Follow link";
      }
    ];
  };
}
