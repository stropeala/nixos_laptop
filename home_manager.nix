{
  config,
  pkgs,
  lib,
  ...
}:

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
      diff.colorMoved = "default";
      alias = {
        s = "status --short --branch";
        l = "log --graph --oneline --decorate";
        pf = "push --force-with-lease";
        undo = "reset --soft HEAD~1";
        amend = "commit --amend --no-edit";
      };
    };

    # Settings -> SSH and GPG keys -> New SSH key -> key type "Signing Key"
    signing = {
      key = "~/.ssh/id_ed25519.pub";
      signByDefault = true;
      format = "ssh";
    };
  };

  programs.delta = {
    enable = true;
    enableGitIntegration = true;
    options.dark = true;
  };

  #========  PROTON VPN
  xdg.configFile = {
    "Proton/VPN/app-config.json".source = ./manager/proton-vpn/app-config.json;
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

  #========  DEV TOOLS
  # auto-loads/unloads a project's .envrc (env vars, nix develop shells) as
  # you cd in and out of directories
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    enableFishIntegration = true;
  };

  #========  TERMINAL QOL
  programs.eza = {
    # nicer `ls` — icons, git status column, tree view
    enable = true;
    enableFishIntegration = true;
    icons = "auto";
    git = true;
  };

  programs.zoxide = {
    # `z <partial-dir-name>` jumps to your most-used matching directory
    enable = true;
    enableFishIntegration = true;
  };

  programs.bat = {
    # nicer `cat` — syntax highlighting, git diff markers, line numbers
    enable = true;
  };

  programs.skim = {
    # fuzzy finder (ctrl+r for history, ctrl+t for files) backed by ripgrep
    enable = true;
    enableFishIntegration = true;
    defaultCommand = "rg --files --hidden --follow --glob '!.git'";
  };

  # use bat for colorized man pages too
  home.sessionVariables.MANPAGER = "sh -c 'col -bx | bat -l man -p'";

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

      touch_scroll_multiplier = 2.69;

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

  #========  POWER MANAGEMENT
  # auto-switch power profile on AC/battery
  # "powerprofilesctl list" shows profiles
  systemd.user.services.power-monitor = {
    Unit = {
      Description = "Auto-switch power profile on AC/battery change";
      After = [ "graphical-session.target" ];
    };
    Service = {
      Type = "simple";
      ExecStart = pkgs.writeShellScript "power-monitor.sh" ''
        BAT=$(echo /sys/class/power_supply/BAT*)
        AC_PROFILE="performance"
        BAT_PROFILE="balanced"
        while true; do
          status=$(cat "$BAT/status" 2>/dev/null)
          if [ "$status" = "Discharging" ]; then
            ${pkgs.power-profiles-daemon}/bin/powerprofilesctl set "$BAT_PROFILE"
          else
            ${pkgs.power-profiles-daemon}/bin/powerprofilesctl set "$AC_PROFILE"
          fi
          ${pkgs.inotify-tools}/bin/inotifywait -qq "$BAT/status" 2>/dev/null || sleep 30
        done
      '';
      Restart = "on-failure";
    };
    Install.WantedBy = [ "default.target" ];
  };

  #========  COREFONTS FOR ONLYOFFICE
  home.activation.installCorefontsForOnlyOffice = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    mkdir -p "$HOME/.local/share/fonts"
    for f in ${pkgs.corefonts}/share/fonts/truetype/*.ttf; do
      cp -f "$f" "$HOME/.local/share/fonts/"
    done
    chmod 644 "$HOME"/.local/share/fonts/*.ttf
    ${pkgs.fontconfig}/bin/fc-cache -f "$HOME/.local/share/fonts" || true
  '';

  #========  KDE PLASMA WALLPAPER
  home.file."Pictures/Wallpapers/skyrim-night-wallpapers.png".source =
    ./manager/plasma/skyrim-night-wallpapers.png;

  #========  AUTOSTART
  xdg.autostart = {
    enable = true;
    readOnly = true;
    entries = [
      "${pkgs.proton-vpn}/share/applications/proton.vpn.app.gtk.desktop"
    ];
  };

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
