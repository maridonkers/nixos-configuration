# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
#
# https://nixos.org/nixos/manual/index.html
# https://nixos.org/nixos/options.html
# https://nixos.wiki/wiki/Configuration_Collection

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Collect nix store garbage and optimise daily.
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

  virtualisation =  {
    docker = {
      enable = true;
      autoPrune.enable = true;
      storageDriver = "btrfs";
      extraOptions = "--iptables=false";
    };

    virtualbox.host.enable = true;
  };

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

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
    pkgs.acpi
    wget
    vim
    cryptsetup
    btrfs-progs
    snapper
    htop
    telnet
    tcpdump
    nmap
    kismet
    screen
    xorg.xhost
    hplipWithPlugin
    keepassxc
    virtualboxWithExtpack
    texlive.combined.scheme-full
    redshift
    redshift-plasma-applet
    filezilla
    thunderbird
    firefox
    chromium
    google-chrome
    xorg.xkill
    emacs
    ag
    kdeApplications.okular
    gwenview
    kate
    kmymoney
    clementineUnfree
    mplayer
    mpv-with-scripts
    rawtherapee
    gimp-with-plugins
    git
    git-crypt
    docker
    docker_compose
    #jdk11
    #openjfx11
    #clojure
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = { enable = true; enableSSHSupport = true; };

  # List services that you want to enable:

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

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = true;

  # Enable CUPS to print documents.
  services.printing.enable = true;

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

  # Required for our screen-lock-on-suspend functionality
  services.logind.extraConfig = ''
    LidSwitchIgnoreInhibited=False
    HandleLidSwitch=suspend
    HoldoffTimeoutSec=10
  '';
      
  # services.redshift = {
  #   enable = true;
  #   latitude = "51.4416";
  #   longitude = "5.4697";
 
  #   temperature = {
  #     day = 6500;
  #     night = 2500;
  #   };
  # };

  # Enable the KDE Desktop Environment.
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;

  services.emacs.enable = false;
  services.emacs.install = true;

  environment.variables = { EDITOR = "vi"; QT_LOGGING_RULES = "*=false"; };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.mdo = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "docker" ]; # Enable ‘sudo’ for the user.
  };

  # Configure snapper for snapshots.
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

