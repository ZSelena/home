{ config, pkgs, inputs, ... }:

let
  startUp = pkgs.pkgs.writeShellScriptBin "start" ''
    ${pkgs.waybar}/bin/waybar'';
  bitwig = pkgs.pkgs.writeShellScriptBin "start" ''
    kitty bitwig-studio
    '';
in
  {
  home.username = "sele";
  home.homeDirectory = "/home/sele";

  home.stateVersion = "25.05"; # Please read the comment before changing.

  home.packages = with pkgs; [

    #facu
    xournalpp
    texliveFull

    bluez
    blueman
    #produ

    (bitwig-studio.override {
      bitwig-studio-unwrapped = (bitwig-studio5-unwrapped.overrideAttrs (oldAttrs: rec{
        version = "6.0";
        src = fetchurl {
          name = "bitwig-studio-${version}.deb";
          url = "https://www.bitwig.com/dl/Bitwig%20Studio/${version}/installer_linux/";
          hash = "sha256-jrCTgaxfeWhfKwLeKLmqTQWS7RVbVnHqJ0InCipmm8k=";
        };

        buildInputs = oldAttrs.buildInputs ++ [yabridge fontconfig];
        postFixup = oldAttrs.postFixup;
      }));
    })
    lsp-plugins
    distrho-ports
    vital
    surge-xt
    reaper
    sunvox

    #media
    vlc
    qbittorrent
    wineWow64Packages.yabridge
    wbg
    yt-dlp
    zathuraPkgs.zathura_djvu

    #terminal
    kitty

    #utilidades
    kdePackages.dolphin
    kdePackages.ark
    rofi
    rofi-network-manager
    mako
    waybar
    gnome-disk-utility
    fzf
    brightnessctl
    lemonade
    slurp
    grim

    #temas
    rose-pine-hyprcursor
    everforest-cursors
    catppuccin-qt5ct

    #fuentes
    maple-mono.NF
    recursive
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autocd = true;
    autosuggestion.enable = true;
  };

  programs.fastfetch.enable = true;

  gtk = {
    enable = true;
    colorScheme = "dark";
    gtk4.theme = null;
  };

  qt = {
    enable = true;
    style = {
      package = pkgs.catppuccin-qt5ct;
      name = "macchiato";
    };
  };

  programs.eww = {
    enable = true;
    configDir = ./eww;
  };

  fonts.fontconfig = {
    enable = true;
    defaultFonts = {
      monospace = ["maple mono"];
    };
  };

  home.sessionVariables = {
    EDITOR = "neovim";
  };

  nixpkgs = {
    config = {
      allowUnfree = true;
      allowUnfreePredicate = (_: true);
    };
  };

  programs.zathura = {
    enable = true;
  };

  home.pointerCursor = {
    enable = true;
    gtk.enable = true;
    package = pkgs.rose-pine-cursor;
    name = "rose-pine-cursor";
    size = 16;
  };

  programs.nvf = {
    enable = true;
    settings.vim = {

      lsp = {
        enable = true;
        lspconfig.enable = true;
      };

      autocomplete = {
        blink-cmp = {
          enable = true;
          setupOpts = {
            cmdline.keymap.preset = "super-tab";
          };
        };
      };

      autopairs.nvim-autopairs.enable = true;

      clipboard = {
        enable = true;
        providers.wl-copy.enable = true;
      };

      options = {
        tabstop = 2;
        shiftwidth = 2;
        foldlevelstart = 4;
      };

      globals = {
        tex_flavor = "latex";
        maplocalleader = " ";
        vimtex_compiler_method = "latexmk";
        vimtex_view_method = "sioyek";
        vimtex_compiler_latexmk = {
          callback = 1;
          continuous = 1;
          executable = "latexmk";
          hooks = [];
          options = [
            "-verbose"
            "-file-line-error"
            "-synctex=1"
            "-interaction=nonstopmode"
            "-shell-escape"
          ];
        };

      };

      lazy.plugins.vimtex = {
        enabled = true;
        package = pkgs.vimPlugins.vimtex;
        lazy = true;
        ft = "tex";
      };

      theme = {
        enable = true;
        name = "everforest";
        style = "hard";
        transparent = true;
      };

      languages = {
        nix.enable = true;
        tex.enable = true;
        lua.enable = true;
      };

      treesitter = {
        enable = true;
        fold = true;
        grammars = with pkgs.vimPlugins.nvim-treesitter.grammarPlugins;[
          nix
          latex
          lua
        ];
      };

      statusline = {
        lualine.enable = true;
      };

      snippets = {
        luasnip = {
          enable = true;
          setupOpts.enable_autosnippets = true;
          loaders =
            ''
            require("luasnip.loaders.from_lua").load({paths = "/home/sele/.config/home-manager/snips/"})
            '';
        };

      };

    };
  };

  programs.kitty = {
    enable = true;
    font = {
      package = pkgs.maple-mono.NF;
      name = "MapleMonoNF";
      size = 11.25;
    };
    extraConfig = ''
    window_padding_width 7
      window_padding_height 10

      font_features MapleMonoNF-Regular +ss01 +ss02 +ss04
      font_features MapleMonoNF-Bold +ss01 +ss02 +ss04
      font_features MapleMonoNF-Italic +ss01 +ss02 +ss04
      font_features MapleMonoNF-Light +ss01 +ss02 +ss04

    shell zsh
      cursor_shape beam
      cursor #E69D42
      cursor_trail 2
    cursor_trail_decay 0.1 0.4
    cursor_trail_start_threshold 0
    cursor_trail_color #e174e3

    background_opacity 0.8
    '';
  };

  programs.starship = {
    enable = true;
    enableZshIntegration = true;
  };

  wayland.windowManager.mango = {
    enable = true;
    settings ={
      bind = [
        #bindings
        "SUPER, m, spawn, rofi -show drun"
        "SUPER, t, spawn, kitty"
        "SUPER, b, spawn, firefox"
        "SUPER+SHIFT, b, spawn, ${bitwig}"
        "SUPER, x, killclient "
        "SUPER, f, togglefloating"
        "SUPER, r, reload_config"
        "SUPER, w, spawn, pkill -SIGUSR1 waybar"
        ''SUPER+SHIFT, s, spawn_shell, grim -g "$(slurp)" -t png - | wl-copy -t image/png''

        #movimientos
        "SUPER, Left, focusdir, left"
        "SUPER, Right, focusdir, right"
        "SUPER, Up, focusdir, up"
        "SUPER, Down, focusdir, down"
        "SUPER+SHIFT, Left, exchange_client, left"
        "SUPER+SHIFT, Right, exchange_client, right"
        "SUPER+SHIFT, Up, focusstack, next"
        "SUPER+SHIFT, Down, focusstack, prev"
        "SUPER+SHIFT, Up, exchange_client, up"
        "SUPER+SHIFT, Down, exchange_client, down"
        "SUPER, l, switch_layout"
        "ALT, T, setlayout, tile"
        "ALT, S, setlayout, scroller"
        "ALT, M, setlayout, monocle"
        "SUPER+CTRL,Up,resizewin,+0,-10"
        "SUPER+CTRL,Down,resizewin,+0,+10"
        "SUPER+CTRL,Left,resizewin,-10,+0"
        "SUPER+CTRL,Right,resizewin,+10,+0"
        "CTRL+ALT, Left, viewtoleft "
        "CTRL+ALT, Right, viewtoright"
        "CTRL+ALT+SHIFT, Right, tagtoright"
        "CTRL+ALT+SHIFT, Left, tagtoleft"

        #brillo
        "NONE,XF86MonBrightnessUp,spawn,brightnessctl s +2%"
        "SHIFT,XF86MonBrightnessUp,spawn,brightnessctl s 100%"
        "NONE,XF86MonBrightnessDown,spawn,brightnessctl s 2%-"
        "SHIFT,XF86MonBrightnessDown,spawn,brightnessctl s 1%"

        #audio
        "NONE,XF86AudioRaiseVolume,spawn,wpctl set-volume @DEFAULT_SINK@ 5%+"
        "NONE,XF86AudioLowerVolume,spawn,wpctl set-volume @DEFAULT_SINK@ 5%-"
        "NONE,XF86AudioMute,spawn,wpctl set-mute @DEFAULT_SINK@ toggle"
        "SHIFT,XF86AudioMute,spawn,wpctl set-mute @DEFAULT_SOURCE@ toggle"
      ];
      mousebind = [
        "SUPER,btn_left,moveresize,curmove"
        "SUPER,btn_right,moveresize,curresize"
      ];
      gesturebind = [
        "none,right,3,viewtoleft"
        "none,left,3,viewtoright"
        "none,up,3,toggleoverview"
        "none,down,3,toggleoverview"
      ];
      exec-once = [
        "waybar"
        "wbg -s /home/sele/Pictures/wallpaper.jpeg"
      ];
      borderpx=2;
      gappov=2;
      gappiv=2;
      gappoh=2;
      gappih=2;
      xkb_rules_layout = "es";
      trackpad_natural_scrolling = 1;
      middle_button_emulation=1;
      disable_while_typing = 0 ;
      cursor_size = 32;
      cursor_theme = "everforest-cursors";
      accel_speed = 1.0 ;
      accel_profile = 1;
      default_mfact = 0.5;
      enable_hotarea = 0;
      sloppyfocus = 0;
    };
    systemd.enable = true;

  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
