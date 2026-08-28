{ config, pkgs, ... }:

{
  home.stateVersion = "26.05";

  #========  ZED
  xdg.configFile = {
    # config
    "zed/settings.json".source = ./manager/zed/settings.json;
    "zed/keymap.json".source = ./manager/zed/keymap.json;
    "zed/tasks.json".source = ./manager/zed/tasks.json;

    # themes
    "zed/themes/custom-catppuccin-mocha_v1.json".source =
      ./manager/zed/themes/custom-catppuccin-mocha_v1.json;
    "zed/themes/custom-catppuccin-mocha_v2.json".source =
      ./manager/zed/themes/custom-catppuccin-mocha_v2.json;
    "zed/themes/custom-catppuccin-mocha_v3.json".source =
      ./manager/zed/themes/custom-catppuccin-mocha_v3.json;
  };

  #========  GIT
  programs.git = {
    enable = true;
    settings = {
      user.name = "Petre Razvan";
      user.email = "petre.ispir2002@protonmail.com";
      init.defaultBranch = "main";
      pull.rebase = false;
    };
  };

  #========  SSH
  # ssh-keygen -t ed25519 -C "petre.ispir2002@protonmail.com"
  programs.ssh = {
    enable = true;
    matchBlocks = {
      "github.com" = {
        identityFile = "~/.ssh/id_ed25519";
      };
    };
  };

  #========  FISH
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      fastfetch
      fish_add_path "/home/lapstrop/.local/bin"
    '';
  };

  #========  KITTY
  programs.kitty = {
    enable = true;
    shellIntegration.enableFishIntegration = true;

    font = {
      name = "JetBrainsMono Nerd Font";
      size = 12.0;
    };

    settings = {
      shell = "/run/current-system/sw/bin/fish";

      background_opacity = "0.92";
      window_padding_width = 10;
      confirm_os_window_close = 0;

      cursor_shape = "beam";
      cursor_blink_interval = 0;

      tab_bar_style = "powerline";
      tab_powerline_style = "slanted";

      # Catppuccin Mocha
      foreground = "#CDD6F4";
      background = "#1E1E2E";
      selection_foreground = "#1E1E2E";
      selection_background = "#F5E0DC";

      color0 = "#45475A";
      color1 = "#F38BA8";
      color2 = "#A6E3A1";
      color3 = "#F9E2AF";
      color4 = "#89B4FA";
      color5 = "#F5C2E7";
      color6 = "#94E2D5";
      color7 = "#BAC2DE";

      color8 = "#585B70";
      color9 = "#F38BA8";
      color10 = "#A6E3A1";
      color11 = "#F9E2AF";
      color12 = "#89B4FA";
      color13 = "#F5C2E7";
      color14 = "#94E2D5";
      color15 = "#A6ADC8";
    };
  };

  #========  GAMING
  # mangohud
  # gamemoderun mangohud %command%
  programs.mangohud = {
    enable = true;
    settings = {
      fps_limit = 59;
      frame_timing = true;
      gpu_stats = true;
      gpu_temp = true;
      gpu_power = true;
      cpu_stats = true;
      cpu_temp = true;
      vram = true;
      ram = true;
      position = "top-left";
      toggle_hud = "Shift_R+F12";
    };
  };

  #========  KDE PLASMA WALLPAPER
  home.file."Pictures/Wallpapers/skyrim-night-wallpapers.png".source =
    ./manager/plasma/skyrim-night-wallpapers.png;

  #========  MIMEAPPS.LIST DEFAULTS
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "application/json" = "dev.zed.Zed.desktop";
      "application/pdf" = "onlyoffice-desktopeditors.desktop";
      "application/x-docbook+xml" = "dev.zed.Zed.desktop";
      "application/x-yaml" = "dev.zed.Zed.desktop";

      "audio/aac" = "vlc.desktop";
      "audio/mp4" = "vlc.desktop";
      "audio/mpeg" = "vlc.desktop";
      "audio/mpegurl" = "vlc.desktop";
      "audio/ogg" = "vlc.desktop";
      "audio/opus" = "vlc.desktop";
      "audio/vnd.rn-realaudio" = "vlc.desktop";
      "audio/vorbis" = "vlc.desktop";
      "audio/webm" = "vlc.desktop";
      "audio/x-aiff" = "vlc.desktop";
      "audio/x-ape" = "vlc.desktop";
      "audio/x-flac" = "vlc.desktop";
      "audio/x-m4a" = "vlc.desktop";
      "audio/x-matroska" = "vlc.desktop";
      "audio/x-mp3" = "vlc.desktop";
      "audio/x-mpegurl" = "vlc.desktop";
      "audio/x-ms-asx" = "vlc.desktop";
      "audio/x-ms-wma" = "vlc.desktop";
      "audio/x-musepack" = "vlc.desktop";
      "audio/x-oggflac" = "vlc.desktop";
      "audio/x-pls" = "vlc.desktop";
      "audio/x-pn-realaudio" = "vlc.desktop";
      "audio/x-scpls" = "vlc.desktop";
      "audio/x-speex" = "vlc.desktop";
      "audio/x-vorbis" = "vlc.desktop";
      "audio/x-vorbis+ogg" = "vlc.desktop";
      "audio/x-wav" = "vlc.desktop";
      "audio/x-wavpack" = "vlc.desktop";

      "video/3gpp" = "org.kde.haruna.desktop";
      "video/3gpp2" = "org.kde.haruna.desktop";
      "video/mp2t" = "org.kde.haruna.desktop";
      "video/mp4" = "org.kde.haruna.desktop";
      "video/mpeg" = "org.kde.haruna.desktop";
      "video/ogg" = "org.kde.haruna.desktop";
      "video/quicktime" = "org.kde.haruna.desktop";
      "video/vnd.rn-realvideo" = "org.kde.haruna.desktop";
      "video/webm" = "org.kde.haruna.desktop";
      "video/x-flv" = "org.kde.haruna.desktop";
      "video/x-matroska" = "org.kde.haruna.desktop";
      "video/x-msvideo" = "org.kde.haruna.desktop";
      "video/x-ms-wmv" = "org.kde.haruna.desktop";
      "video/x-ogm+ogg" = "org.kde.haruna.desktop";
      "video/x-theora+ogg" = "org.kde.haruna.desktop";

      "text/markdown" = "dev.zed.Zed.desktop";
      "text/plain" = "dev.zed.Zed.desktop";
      "text/x-cmake" = "dev.zed.Zed.desktop";

      "x-scheme-handler/geo" = "google-maps-geo-handler.desktop";
      "x-scheme-handler/proton-inbox" = "proton-mail.desktop";
      "x-scheme-handler/discord" = "legcord.desktop";
      "x-scheme-handler/x-github-client" = "github-desktop.desktop";
      "x-scheme-handler/x-github-desktop-dev-auth" = "github-desktop.desktop";
      "x-scheme-handler/http" = "brave-browser.desktop";
      "x-scheme-handler/https" = "brave-browser.desktop";
    };
  };
}
