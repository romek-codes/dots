{ config, ... }: {
  programs.nixvim = {
    plugins.mini = {
      enable = true;
      mockDevIcons = true;
      modules = {
        icons = { };
        bracketed = { };
        files = { };
        git = { };
        diff = { };
        starter = { };
        pairs = { };
        notify = { lsp_progress.enable = false; };
        indentscope = { };
        cursorword = { };
        comment = {
          mappings = {
            comment = "<leader>/";
            comment_line = "<leader>/";
            comment_visual = "<leader>/";
            textobject = "<leader>/";
          };
        };
        starter = { };
      };
    };
  };
}
