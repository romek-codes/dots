{
  programs.nixvim = {
    plugins.which-key = {
      enable = true;
      settings = {
        delay = 600;
        icons = {
          breadcrumb = "»";
          group = "+";
          separator = ""; # ➜
          mappings = false;
        };
        spec = [
          # General Mappings
          {
            __unkeyed-1 = "<leader>u";
            mode = "n";
            group = "+ui";
          }
          {
            __unkeyed-1 = "<leader>w";
            mode = "n";
            group = "+windows";
          }
          {
            __unkeyed-1 = "<leader>c";
            mode = "n";
            group = "+code";
          }
        ];
        win = {
          border = "rounded";
          wo.winblend = 0;
        };
      };
    };

    keymaps = [
      # General Mappings
      {
        key = "s";
        action = "<cmd>lua require('flash').jump()<cr>";
        options.desc = "Flash";
      }
      {
        key = "K";
        action = "<cmd>lua vim.lsp.buf.hover()<cr>";
        options.desc = "LSP Hover";
      }
      {
        key = "<C-tab>";
        action = "<cmd>bnext<cr>";
        options.desc = "Next Buffer";
      }

      # Tmux
      {
        key = "<C-h>";
        action = "<cmd>TmuxNavigateLeft<cr>";
      }
      {
        key = "<C-j>";
        action = "<cmd>TmuxNavigateDown<cr>";
      }
      {
        key = "<C-k>";
        action = "<cmd>TmuxNavigateUp<cr>";
      }
      {
        key = "<C-l>";
        action = "<cmd>TmuxNavigateRight<cr>";
      }

      # Disable Arrow Keys in Normal Mode
      {
        key = "<Up>";
        action = "<Nop>";
        options.desc = "Disable Up Arrow";
      }
      {
        key = "<Down>";
        action = "<Nop>";
        options.desc = "Disable Down Arrow";
      }
      {
        key = "<Left>";
        action = "<Nop>";
        options.desc = "Disable Left Arrow";
      }
      {
        key = "<Right>";
        action = "<Nop>";
        options.desc = "Disable Right Arrow";
      }

      # UI
      {
        key = "<leader>uw";
        action = "<cmd>set wrap!<cr>";
        options.desc = "Toggle word wrapping";
      }
      {
        key = "<leader>ul";
        action = "<cmd>set linebreak!<cr>";
        options.desc = "Toggle linebreak";
      }
      {
        key = "<leader>us";
        action = "<cmd>set spell!<cr>";
        options.desc = "Toggle spellLazyGitcheck";
      }
      {
        key = "<leader>uc";
        action = "<cmd>set cursorline!<cr>";
        options.desc = "Toggle cursorline";
      }
      {
        key = "<leader>un";
        action = "<cmd>set number!<cr>";
        options.desc = "Toggle line numbers";
      }
      {
        key = "<leader>ur";
        action = "<cmd>set relativenumber!<cr>";
        options.desc = "Toggle relative line numbers";
      }
      {
        key = "<leader>ut";
        action = "<cmd>set showtabline=2<cr>";
        options.desc = "Show tabline";
      }
      {
        key = "<leader>uT";
        action = "<cmd>set showtabline=0<cr>";
        options.desc = "Hide tabline";
      }

      # Windows
      {
        key = "<leader>ws";
        action = "<cmd>split<cr>";
        options.desc = "Split";
      }
      {
        key = "<leader>wv";
        action = "<cmd>vsplit<cr>";
        options.desc = "VSplit";
      }
      {
        key = "<leader>wd";
        action = "<cmd>close<cr>";
        options.desc = "Close";
      }

      {
        key = "<leader>q";
        action = "<cmd>quit<cr>";
        options.desc = "Quit";
      }
      {
        key = "<leader>w";
        action = "<cmd>write<cr>";
        options.desc = "Save";
      }
      # {
      #   key = "<leader>/";
      #   action =
      #     "<cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<cr>";
      #   options.desc = "Toggle comment";
      # }
      {
        key = "]b";
        action = "<cmd>lua require('astrocore.buffer').nav(vim.v.count1)<cr>";
        options.desc = "Next buffer";
      }
      {
        key = "[b";
        action = "<cmd>lua require('astrocore.buffer').nav(-vim.v.count1)<cr>";
        options.desc = "Previous buffer";
      }
      {
        key = "<Leader>bd";
        action =
          "<cmd>lua require('astroui.status.heirline').buffer_picker(function(bufnr) require('astrocore.buffer').close(bufnr) end)<cr>";
        options.desc = "Close buffer from tabline";
      }
      {
        key = "<Leader>lpg";
        action = "<cmd>lua require('neogen').generate()<cr>";
        options.desc = "Generate documentation";
      }
      {
        key = "<Leader>lpc";
        action = "<cmd>lua require('neogen').generate({ type = 'class' })<cr>";
        options.desc = "Generate class documentation";
      }
      {
        key = "<Leader>lpf";
        action = "<cmd>lua require('neogen').generate({ type = 'func' })<cr>";
        options.desc = "Generate function documentation";
      }
      {
        key = "<Leader>lh";
        action = "<cmd>lua require('lsp_lines').toggle()<cr>";
        options.desc = "Toggle_lsp_lines";
      }
      {
        key = "<Leader>e";
        action = "<cmd>lua MiniFiles.open()<cr>";
        options.desc = "Show explorer";
      }
      {
        key = "<Leader>ld";
        action = "<cmd>lua vim.diagnostic.setqflist()<cr>";
        options.desc = "Show issues";
      }
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
      {
        key = "<Leader>nh";
        action = "<cmd>Noice history<cr>";
        options.desc = "History";
      }
      {
        key = "<Leader>nd";
        action = "<cmd>Noice dismiss<cr>";
        options.desc = "Dismiss";
      }
      {
        key = "<Leader>nl";
        action = "<cmd>Noice last<cr>";
        options.desc = "Last message";
      }
      {
        key = "<Leader>ne";
        action = "<cmd>Noice errors<cr>";
        options.desc = "Errors";
      }
      {
        key = "<Leader>Br";
        action = "<cmd>BrunoRun<cr>";
        options.desc = "Run";
      }
      {
        key = "<Leader>Be";
        action = "<cmd>BrunoEnv<cr>";
        options.desc = "Environment";
      }
      {
        key = "<Leader>Bs";
        action = "<cmd>BrunoSearch<cr>";
        options.desc = "Search";
      }
      {
        key = "<Leader>fr";
        action = "<cmd>Spectre<cr>";
        options.desc = "Find & Replace";
      }
      # {
      #  key = "<Leader>fw";
      #  action =
      # "<cmd>lua require('telescope').extensions.live_grep_args.live_grep_args{}<cr>";
      # options.desc = "Find word";
      # }
    ];
  };
}
