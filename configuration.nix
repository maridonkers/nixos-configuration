# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
#
# https://nixos.org/nixos/manual/index.html
# https://nixos.org/nixos/options.html
# https://nixos.wiki/wiki/Configuration_Collection
#
#

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Root filesystem.
  #
  fileSystems."/" =
    { device = "/dev/disk/by-uuid/9b21328e-e925-4bd9-9cb0-c37d4cb5bb32";
      fsType = "btrfs";
      options = [ "subvol=nixos" "noatime" "space_cache" "autodefrag" ];
    };

  fileSystems."/var" =
    { device = "/dev/disk/by-uuid/9b21328e-e925-4bd9-9cb0-c37d4cb5bb32";
      fsType = "btrfs";
      options = [ "subvol=nixos/var" "noatime" "space_cache" "autodefrag" ];
    };

  fileSystems."/tmp" =
    { device = "/dev/disk/by-uuid/9b21328e-e925-4bd9-9cb0-c37d4cb5bb32";
      fsType = "btrfs";
      options = [ "subvol=nixos/tmp" "noatime" "space_cache" "autodefrag" ];
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/dc12fafa-47e3-4f7c-a6a4-f3c14e06b4ff";
      fsType = "ext4";
      options = [ "noatime" ];
    };

  # Encrypted partitions.
  #
  boot.initrd.luks.devices."cr1-home" = {
      device = "/dev/disk/by-uuid/0184c496-d27d-4c70-88f6-d0b7aaed1e17";
    };

  boot.initrd.luks.devices."cr2-data" = {
      device = "/dev/disk/by-uuid/75236c0e-cad4-43a7-986c-a5f82f68cf65";
    };

  fileSystems."/home" =
    { device = "/dev/mapper/cr1-home";
      fsType = "btrfs";
      options = [ "noatime" "space_cache" "autodefrag" ];
    };

  fileSystems."/home/mdo/.cache" =
    { device = "/dev/mapper/cr1-home";
      fsType = "btrfs";
      options = [ "subvol=mdo/.cache" "noatime" "space_cache" "autodefrag" ];
    };

  fileSystems."/home/mdo/.m2" =
    { device = "/dev/mapper/cr1-home";
      fsType = "btrfs";
      options = [ "subvol=mdo/.m2" "noatime" "space_cache" "autodefrag" ];
    };

  fileSystems."/home/mdo/.mozilla" =
    { device = "/dev/mapper/cr1-home";
      fsType = "btrfs";
      options = [ "subvol=mdo/.mozilla" "noatime" "space_cache" "autodefrag" ];
    };

  fileSystems."/home/mdo/.thunderbird" =
    { device = "/dev/mapper/cr1-home";
      fsType = "btrfs";
      options = [ "subvol=mdo/.thunderbird" "noatime" "space_cache" "autodefrag" ];
    };

  fileSystems."/home/mdo/.config" =
    { device = "/dev/mapper/cr1-home";
      fsType = "btrfs";
      options = [ "subvol=mdo/.config" "noatime" "space_cache" "autodefrag" ];
    };

  fileSystems."/mnt/data" =
    { device = "/dev/mapper/cr2-data";
      fsType = "btrfs";
      options = [ "noatime" "space_cache" "autodefrag" ];
    };

  fileSystems."/home/mdo/Music" =
    { device = "/dev/mapper/cr2-data";
      fsType = "btrfs";
      options = [ "subvol=music" "noatime" "space_cache" "autodefrag" ];
    };

  fileSystems."/home/mdo/Pictures" =
    { device = "/dev/mapper/cr2-data";
      fsType = "btrfs";
      options = [ "subvol=pictures" "noatime" "space_cache" "autodefrag" ];
    };

  fileSystems."/home/mdo/ISO" =
    { device = "/dev/mapper/cr2-data";
      fsType = "btrfs";
      options = [ "subvol=iso" "noatime" "space_cache" "autodefrag" ];
    };

  fileSystems."/home/mdo/android" =
    { device = "/dev/mapper/cr2-data";
      fsType = "btrfs";
      options = [ "subvol=android" "noatime" "space_cache" "autodefrag" ];
    };

  fileSystems."/home/mdo/Backups" =
    { device = "/dev/mapper/cr2-data";
      fsType = "btrfs";
      options = [ "subvol=backups" "noatime" "space_cache" "autodefrag" ];
    };

  fileSystems."/home/mdo/Videos" =
    { device = "/dev/mapper/cr2-data";
      fsType = "btrfs";
      options = [ "subvol=videos" "noatime" "space_cache" "autodefrag" ];
    };

  fileSystems."/home/mdo/src" =
    { device = "/dev/mapper/cr2-data";
      fsType = "btrfs";
      options = [ "subvol=src" "noatime" "space_cache" "autodefrag" ];
    };

  fileSystems."/home/mdo/Media" =
    { device = "/dev/mapper/cr2-data";
      fsType = "btrfs";
      options = [ "subvol=media" "noatime" "space_cache" "autodefrag" ];
    };

  fileSystems."/home/mdo/Downloads" =
    { device = "/dev/mapper/cr2-data";
      fsType = "btrfs";
      options = [ "subvol=downloads" "noatime" "space_cache" "autodefrag" ];
    };

  swapDevices =
    [ { device = "/dev/disk/by-uuid/99be5bc9-fac4-4386-83c0-63632edef9dc"; }
    ];

  # Collect nix store garbage and optimize daily.
  nix.gc.automatic = true;
  nix.optimise.automatic = true;

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  # boot.loader.grub.efiSupport = true;
  # boot.loader.grub.efiInstallAsRemovable = true;
  # boot.loader.efi.efiSysMountPoint = "/boot/efi";
  # Define on which hard drive you want to install Grub.
  boot.loader.grub.device = "/dev/sda"; # or "nodev" for efi only
  # boot.loader.grub.extraConfig = "terminal_input_console terminal_output_console";

  networking.hostName = "sapientia"; # Define your hostname.
  networking.networkmanager.enable = true;
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  #

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = true;

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.ens5.useDHCP = true;
  networking.interfaces.wlp3s0.useDHCP = true;

  programs.wireshark = {
    enable = true;
    package = pkgs.wireshark;
  };

  services.clamav = {
    # daemon.enable = true;
    updater.enable = true;
  };


  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";
  
  # Docker host. The --iptables=false makes sure that Docker doesn't alter
  # the firewall (as a default containers should no be accessible from outside).
  #
  virtualisation =  {
    docker = {
      enable = true;
      autoPrune.enable = true;
      storageDriver = "btrfs";
      extraOptions = "--iptables=false";
    };

    libvirtd.enable = true;
  };

  # Enable nested virtualization for your guests to run KVM hypervisors
  boot.extraModprobeConfig = "options kvm_intel nested=1";

  # Select internationalisation properties.
  i18n = {
    consoleFont = "Lat2-Terminus16";
    consoleKeyMap = "us";
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = { LC_MESSAGES = "en_US.UTF-8"; LC_TIME = "nl_NL.UTF-8"; };
  };

  # Set your time zone.
  time.timeZone = "Europe/Amsterdam";

  # Allow packages with non-free licenses.
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    microcodeIntel
    acpi
    smartmontools
    hddtemp
    file
    wget
    vim
    cryptsetup
    btrfs-progs
    snapper
    clamav
    yara
    lynis
    htop
    openvpn
    wirelesstools
    telnet
    tcpdump
    nmap
    kismet
    screen
    xorg.xhost
    openssl
    gnupg
    keepassxc
    virtmanager
    libguestfs
    texlive.combined.scheme-full
    pandoc 
    redshift
    redshift-plasma-applet
    filezilla
    unzip
    p7zip
    mutt
    thunderbird
    firefox
    chromium
    google-chrome
    brave
    tor-browser-bundle-bin
    xorg.xkill
    xorg.xeyes
    emacs
    ag
    kdeApplications.okular
    kdeApplications.krdc
    kdeApplications.marble
    kdeApplications.kdenlive 
    gwenview
    kate
    kmymoney
    clementineUnfree
    mplayer
    mpv-with-scripts
    digikam
    krita
    rawtherapee
    gimp-with-plugins
    libreoffice
    git
    git-crypt
    gitAndTools.gitRemoteGcrypt
    docker
    docker_compose
    kdiff3-qt5
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = { enable = true; enableSSHSupport = true; };

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;
  services.openssh = {
    enable = true;

    # Only pubkey auth
    passwordAuthentication = false;
    challengeResponseAuthentication = false;
  };

  # Start ssh-agent as a systemd user service
  programs.ssh.startAgent = true;

  # Printing. Enable CUPS to print documents.
  # https://nixos.wiki/wiki/Printing
  services.printing.enable = true;
  services.printing.drivers = with pkgs; [ hplipWithPlugin ];

  # Scanning with sane.
  hardware.sane.enable = true;
  hardware.sane.extraBackends = with pkgs; [ hplipWithPlugin ];

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio = {
    enable = true;
    # support32Bit = true;
  };

  # OpenGL configuration.
  hardware.opengl = {
    enable = true;
    driSupport32Bit = true;
    s3tcSupport = true;
  };

  # Power saving settings.
  networking.networkmanager.wifi.powersave = true;

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.layout = "us";
  services.xserver.xkbOptions = "eurosign:e";

  # Enable touchpad support.
  # services.xserver.libinput.enable = true;

  # Required for screen-lock-on-suspend functionality.
  services.logind.extraConfig = ''
    LidSwitchIgnoreInhibited=False
    HandleLidSwitch=suspend
    HoldoffTimeoutSec=10
  '';
      
  # Enable the KDE Desktop Environment.
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;

  # Environment variables.
  environment.variables = { EDITOR = "vi"; QT_LOGGING_RULES = "*=false"; };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.mdo = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "docker" "libvirtd"
                    "audio" "disk" "video" "networkmanager"
                    "systemd-journal" "lp" "scanner" ]; # Enable ‘sudo’ for the user.
  };

  # Configure snapper for automated snapshots.
  #
  services.snapper.configs = {
    "root" = {
      subvolume = "/";
      extraConfig = ''
        ALLOW_USERS="mdo"
        TIMELINE_CREATE="yes"
        TIMELINE_CLEANUP="yes"
        TIMELINE_LIMIT_HOURLY="12"
        TIMELINE_LIMIT_DAILY="7"
        TIMELINE_LIMIT_WEEKLY="4"
        TIMELINE_LIMIT_MONTHLY="6"
        TIMELINE_LIMIT_YEARLY="0"
      '';
    };
    "home" = {
      subvolume = "/home";
      extraConfig = ''
        ALLOW_USERS="mdo"
        TIMELINE_CREATE="yes"
        TIMELINE_CLEANUP="yes"
        TIMELINE_LIMIT_HOURLY="12"
        TIMELINE_LIMIT_DAILY="7"
        TIMELINE_LIMIT_WEEKLY="4"
        TIMELINE_LIMIT_MONTHLY="6"
        TIMELINE_LIMIT_YEARLY="0"
      '';
    };
    "music" = {
      subvolume = "/mnt/data/music";
      extraConfig = ''
        ALLOW_USERS="mdo"
        TIMELINE_CREATE="yes"
        TIMELINE_CLEANUP="yes"
        TIMELINE_LIMIT_HOURLY="12"
        TIMELINE_LIMIT_DAILY="7"
        TIMELINE_LIMIT_WEEKLY="4"
        TIMELINE_LIMIT_MONTHLY="6"
        TIMELINE_LIMIT_YEARLY="0"
      '';
    };
    "media" = {
      subvolume = "/mnt/data/media";
      extraConfig = ''
        ALLOW_USERS="mdo"
        TIMELINE_CREATE="yes"
        TIMELINE_CLEANUP="yes"
        TIMELINE_LIMIT_HOURLY="12"
        TIMELINE_LIMIT_DAILY="7"
        TIMELINE_LIMIT_WEEKLY="4"
        TIMELINE_LIMIT_MONTHLY="6"
        TIMELINE_LIMIT_YEARLY="0"
      '';
    };
    "pictures" = {
      subvolume = "/mnt/data/pictures";
      extraConfig = ''
        ALLOW_USERS="mdo"
        TIMELINE_CREATE="yes"
        TIMELINE_CLEANUP="yes"
        TIMELINE_LIMIT_HOURLY="12"
        TIMELINE_LIMIT_DAILY="7"
        TIMELINE_LIMIT_WEEKLY="4"
        TIMELINE_LIMIT_MONTHLY="6"
        TIMELINE_LIMIT_YEARLY="0"
      '';
    };
    "videos" = {
      subvolume = "/mnt/data/videos";
      extraConfig = ''
        ALLOW_USERS="mdo"
        TIMELINE_CREATE="yes"
        TIMELINE_CLEANUP="yes"
        TIMELINE_LIMIT_HOURLY="12"
        TIMELINE_LIMIT_DAILY="7"
        TIMELINE_LIMIT_WEEKLY="4"
        TIMELINE_LIMIT_MONTHLY="6"
        TIMELINE_LIMIT_YEARLY="0"
      '';
    };
     "mdo.config" = {
       subvolume = "/home/mdo/.config";
       extraConfig = ''
         ALLOW_USERS="mdo"
         TIMELINE_CREATE="yes"
         TIMELINE_CLEANUP="yes"
         TIMELINE_LIMIT_HOURLY="12"
         TIMELINE_LIMIT_DAILY="7"
         TIMELINE_LIMIT_WEEKLY="4"
         TIMELINE_LIMIT_MONTHLY="6"
         TIMELINE_LIMIT_YEARLY="0"
       '';
    };
    "mdo.m2" = {
      subvolume = "/home/mdo/.m2";
      extraConfig = ''
        ALLOW_USERS="mdo"
        TIMELINE_CREATE="yes"
        TIMELINE_CLEANUP="yes"
        TIMELINE_LIMIT_HOURLY="12"
        TIMELINE_LIMIT_DAILY="7"
        TIMELINE_LIMIT_WEEKLY="4"
        TIMELINE_LIMIT_MONTHLY="6"
        TIMELINE_LIMIT_YEARLY="0"
      '';
    };
    "mdo.mozilla" = {
      subvolume = "/home/mdo/.mozilla";
      extraConfig = ''
        ALLOW_USERS="mdo"
        TIMELINE_CREATE="yes"
        TIMELINE_CLEANUP="yes"
        TIMELINE_LIMIT_HOURLY="12"
        TIMELINE_LIMIT_DAILY="7"
        TIMELINE_LIMIT_WEEKLY="4"
        TIMELINE_LIMIT_MONTHLY="6"
        TIMELINE_LIMIT_YEARLY="0"
      '';
    };
    "mdo.thunderbird" = {
      subvolume = "/home/mdo/.thunderbird";
      extraConfig = ''
        ALLOW_USERS="mdo"
        TIMELINE_CREATE="yes"
        TIMELINE_CLEANUP="yes"
        TIMELINE_LIMIT_HOURLY="12"
        TIMELINE_LIMIT_DAILY="7"
        TIMELINE_LIMIT_WEEKLY="4"
        TIMELINE_LIMIT_MONTHLY="6"
        TIMELINE_LIMIT_YEARLY="0"
      '';
    };
  };

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "19.09"; # Did you read the comment?

}

