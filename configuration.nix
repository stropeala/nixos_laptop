# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  #========  FLAKES
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  systemd.services.NetworkManager-wait-online.enable = false;

  # nix automatic garbage collector
  nix.gc = {
    automatic = true;
    dates = "daily";
    options = "--delete-older-than 7d";
  };
  nix.settings.auto-optimise-store = true;
  boot.tmp.cleanOnBoot = true;

  #========  BOOT
  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "26.05"; # Did you read the comment?

  #========  NETWORKING
  # Define your hostname.
  networking.hostName = "lapstrop";

  # Enable networking
  networking.networkmanager.enable = true;

  # Enable bluetooth
  hardware.bluetooth.enable = true;

  # Configure network proxy if necessary
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # networking.firewall.enable = false;

  #========  LOCAL & TIME
  # Set your time zone.
  time.timeZone = "Europe/Bucharest";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "ro_RO.UTF-8";
    LC_IDENTIFICATION = "ro_RO.UTF-8";
    LC_MEASUREMENT = "ro_RO.UTF-8";
    LC_MONETARY = "ro_RO.UTF-8";
    LC_NAME = "ro_RO.UTF-8";
    LC_NUMERIC = "ro_RO.UTF-8";
    LC_PAPER = "ro_RO.UTF-8";
    LC_TELEPHONE = "ro_RO.UTF-8";
    LC_TIME = "ro_RO.UTF-8";
  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  #========  DESKTOP ENVIRONMENT
  # Enable the X11 windowing system.
  # You can disable this if you're only using the Wayland session.
  #services.xserver.enable = true;

  # Enable the KDE Plasma Desktop Environment.
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  #========  PRINTING
  # Enable CUPS to print documents.
  services.printing.enable = true;

  #========  AUDIO
  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  #========  TOUCHPAD
  # Enable touchpad support (enabled default in most desktopManager).
  services.xserver.libinput.enable = true;

  #========  USER
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users."lapstrop" = {
    isNormalUser = true;
    description = "lapstrop";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
    shell = pkgs.fish;
    packages = with pkgs; [
      kdePackages.kate
      # thunderbird
    ];
  };

  nixpkgs.config.allowUnfree = true;

  #========  SHELL
  programs.fish.enable = true;

  #========  DEV TOOLS
  # enabled this for zed
  programs.nix-ld.enable = true;

  #========  AMD
  # needed for Steam/Proton
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  #services.xserver.videoDrivers = [ "amdgpu" ];

  #========  GAMING
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    #dedicatedServer.openFirewall = true;
  };

  # zen kernel
  #boot.kernelPackages = pkgs.linuxPackages_zen;

  # latest vanilla linux kernel
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # ntsync
  #boot.kernelModules = [ "ntsync" ];
  #services.udev.packages = [
  #(pkgs.writeTextFile {
  #name = "ntsync-udev-rules";
  #text = ''KERNEL=="ntsync", MODE="0660", TAG+="uaccess"'';
  #destination = "/etc/udev/rules.d/70-ntsync.rules";
  #})
  #];

  # gamemoderun %command%
  programs.gamemode = {
    enable = true;
    enableRenice = true;
  };

  # gamescope -W 1920 -H 1600 -f --mangoapp -- gamemoderun %command%
  programs.gamescope = {
    enable = true;
    #capSysNice = true;
    env = {
      ENABLE_GAMESCOPE_WSI = "0";
    };
  };

  boot.kernel.sysctl = {
    "vm.max_map_count" = 2147483647;
    "vm.swappiness" = 150;
    "vm.page-cluster" = 0;
    "vm.dirty_bytes" = 268435456;
    "vm.dirty_background_bytes" = 67108864;
    "kernel.nmi_watchdog" = 1;
  };

  # kernel log
  # journalctl -b -1 -k | grep -iE "nvrm|xid|oom|hung|bug:"
  services.journald.storage = "persistent";

  # compressed RAM swap
  zramSwap = {
    enable = true;
    memoryPercent = 50;
  };

  # amd cpu microcode updates
  hardware.enableRedistributableFirmware = true;

  # power management
  #powerManagement.scsiLinkPolicy = "max_performance";
  # asus notebook control
  services.asusd.enable = true;
  systemd.tmpfiles.rules = [ "d /etc/asusd 0755 root root -" ];

  # device rules that apply automatically whenever a matching drive/module is detected
  services.udev.extraRules = ''
    ACTION=="add|change", KERNEL=="sd[a-z]*", ATTR{queue/rotational}=="1", ATTR{queue/scheduler}="bfq"
    ACTION=="add|change", KERNEL=="sd[a-z]*|mmcblk[0-9]*", ATTR{queue/rotational}=="0", ATTR{queue/scheduler}="mq-deadline"
    ACTION=="add|change", KERNEL=="nvme[0-9]*", ATTR{queue/rotational}=="0", ATTR{queue/scheduler}="none"
    ACTION=="add|change", KERNEL=="sd[a-z]", ATTR{queue/rotational}=="1", ATTRS{id/bus}=="ata", RUN+="${pkgs.hdparm}/bin/hdparm -B 254 -S 0 /dev/%k"
  '';

  #========  BROWSER
  programs.firefox.enable = true;

  environment.sessionVariables = {
    BROWSER = "brave";
  };

  #========  MOUNTS
  fileSystems."/mnt/WINDOWS169" = {
    device = "/dev/disk/by-uuid/641A67331A670182";
    fsType = "ntfs";
    options = [
      "defaults"
      "rw"
      "uid=1000"
      "gid=100"
    ];
  };

  fileSystems."/mnt/PROTONDRIVE30" = {
    device = "/dev/disk/by-uuid/26BA51A8BA517571";
    fsType = "ntfs";
    options = [
      "defaults"
      "rw"
      "uid=1000"
      "gid=100"
    ];
  };

  swapDevices = [
    {
      device = "/swapfile";
      size = 8 * 1024;
    }
  ];

  #========  PACKAGES
  programs.nix-index.enable = true;
  environment.systemPackages = with pkgs; [
    # was here on install
    wget

    # terminal
    kitty

    # programming languages & tools
    rustup
    uv
    #python3
    #python3Packages.pip
    gcc
    pkg-config
    sqlite
    postgresql
    git
    github-desktop
    zed-editor
    nixd
    nil

    # filesystems
    ntfs3g
    gnutar
    xz
    zstd

    # gaming
    #steam
    #protonup-qt
    protonplus
    #mangohud

    # proton suite
    proton-pass
    protonmail-desktop
    proton-vpn

    # apps
    zapzap
    tidal-hifi
    legcord
    bleachbit
    onlyoffice-desktopeditors
    sqlitebrowser
    qbittorrent
    brave
    vlc
    haruna

    # utilities
    fastfetch
    kdePackages.filelight
    btop
    jetbrains-mono
    kdePackages.partitionmanager
    asusctl

    # kde plasma sddm login screen wallpaper
    (pkgs.writeTextDir "share/sddm/themes/breeze/theme.conf.user" ''
      [General]
      background=${./manager/plasma/skyrim-night-wallpapers.png}
      type=image
    '')
  ];

  #========  OPTIONAL
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;
}
