# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
#
# https://nixos.org/nixos/manual/index.html
# https://nixos.org/nixos/options.html
# https://nixos.wiki/wiki/Configuration_Collection
#

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./fs-configuration.nix
      ./env-configuration.nix
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
  
  # Kernel parameters.
  boot.kernelParams = [ "apci_osi=Linux" ];

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
      #extraOptions = "--iptables=false";
    };

    libvirtd.enable = true;
  };

  # Enable nested virtualization for your guests to run KVM hypervisors
  boot.extraModprobeConfig = "options kvm_intel nested=1";

  # Select internationalisation properties.
  i18n = {
    #consoleFont = "Lat2-Terminus16";
    #consoleKeyMap = "us";
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = { LC_MESSAGES = "en_US.UTF-8"; LC_TIME = "nl_NL.UTF-8"; };
  };

  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  # Set your time zone.
  time.timeZone = "Europe/Amsterdam";

  # Allow packages with non-free licenses.
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    microcodeIntel
    #acpi
    #acpid
    #pmtools
    smartmontools
    hddtemp
    file
    wget
    binutils-unwrapped
    tree
    vim
    cryptsetup
    btrfs-progs
    rmlint
    snapper
    restic
    clamav
    yara
    lynis
    usbutils
    heimdall-gui
    openvpn
    jwhois
    wirelesstools
    telnet
    tcpdump
    nmap
    kismet
    screen
    xorg.xhost
    sshfs
    openssl
    gnupg
    keepassxc
    virtmanager
    libguestfs
    texlive.combined.scheme-full
    ascii
    pandoc 
    redshift
    redshift-plasma-applet
    filezilla
    apktool
    unzip
    p7zip
    ark
    mutt
    thunderbird
    firefox
    chromium
    google-chrome
    brave
    xorg.xkill
    xorg.xeyes
    emacs
    ag
    notmuch
    offlineimap
    kdeApplications.okular
    kdeApplications.krdc
    kdeApplications.marble
    kdeApplications.kdenlive 
    gwenview
    kate
    #kmymoney
    hledger
    hledger-ui
    wcalc
    clementineUnfree
    libav
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
    mercurial
    docker
    docker_compose
    kdiff3-qt5
    jitsi
    html-tidy
    par
    banner
  ];

  services.fwupd.enable = true;

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

  # https://nixos.wiki/wiki/Android
  programs.adb.enable = true;

  # Enable touchpad support.
  # services.xserver.libinput.enable = true;

  # Required for screen-lock-on-suspend functionality.
  services.logind.extraConfig = ''
    LidSwitchIgnoreInhibited=False
    HandleLidSwitch=suspend
    HoldoffTimeoutSec=10
  '';
      
  # Enable the KDE Desktop Environment.
  services.xserver = {
    displayManager.sddm.enable = true;
    desktopManager.plasma5.enable = true;
  };

  # https://nixos.wiki/wiki/Fonts
  fonts.fonts = with pkgs; [
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
 #   liberation_ttf
 #   fira-code
 #   fira-code-symbols
 #   mplus-outline-fonts
 #   dina-font
 #   proggyfonts
  ];

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.mdo = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "docker" "libvirtd"
                    "audio" "disk" "video" "networkmanager"
                    "systemd-journal" "lp" "scanner" "adbusers" ];
    # Enable ‘sudo’ for the user.
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
  system.stateVersion = "20.03"; # Did you read the comment?
}

