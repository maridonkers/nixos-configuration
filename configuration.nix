# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
#
# https://nixos.org/nixos/manual/index.html
# https://nixos.org/nixos/options.html
# https://nixos.wiki/wiki/Configuration_Collection
#

{ config, pkgs, ... }:

let unstable = import <nixos-unstable> { config = { allowUnfree = true; }; };
in {
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./fs-configuration.nix
      ./network-configuration.nix
      ./env-configuration.nix
      ./cachix.nix
    ];

  # https://nixos.wiki/wiki/Storage_optimization
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 31d";
  };

  # nix.extraOptions = ''
  #   min-free = ${toString (5 * 1024 * 1024 * 1024)} # 5 GB
  #   max-free = ${toString (10* 1024 * 1024 * 1024)}
  # '';

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  # boot.loader.grub.efiSupport = true;
  # boot.loader.grub.efiInstallAsRemovable = true;
  # boot.loader.efi.efiSysMountPoint = "/boot/efi";
  # Define on which hard drive you want to install Grub.
  boot.loader.grub.device = "/dev/disk/by-id/ata-WDC_WD5000BEKT-60KA9T0_WD-WXG1AA0N9929"; # or "nodev" for efi only
  # boot.loader.grub.extraConfig = "terminal_input_console terminal_output_console";
  
  # Kernel parameters.
  boot.kernelParams = [ "apci_osi=Linux" ];

  # Obelisk/Reflex -- https://github.com/obsidiansystems/obelisk
  nix.binaryCaches = [ "https://nixcache.reflex-frp.org" ];
  nix.binaryCachePublicKeys = [ "ryantrinkle.com-1:JJiAKaRv9mWgpVAz8dwewnZe0AzzEAzPkagE9SP5NWI=" ];

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
      storageDriver = "overlay2";
      #extraOptions = "--iptables=false";
    };

    libvirtd.enable = true;
  };

  # Enable nested virtualization for your guests to run KVM hypervisors
  boot.extraModprobeConfig = "options kvm_intel nested=1";

  # Font size.
  fonts.fontconfig.dpi=96;

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
  # `nix search wget`
  environment.systemPackages = with pkgs; [
    nix-prefetch-scripts
    microcodeIntel
    #acpi
    #acpid
    #pmtools
    smartmontools
    hddtemp
    file
    wget
    binutils-unwrapped
    toybox
    pstree
    tree
    htop
    ccache
    # cachix
    entr
    pkg-config
    vim
    zile
    cryptsetup
    e2fsprogs
    btrfs-progs
    rmlint
    snapper
    restic
    clamav
    yara
    lynis
    usbutils
    beep
    heimdall-gui
    # Packages from unstable because of the no network after resume from suspend bug.
    #unstable.dhcpcd 
    #unstable.wpa_supplicant
    wirelesstools
    openvpn
    telnet
    tcpdump
    nmap
    kismet
    metasploit
    speedtest-cli
    screen
    tmux
    xorg.xhost
    xorg.xmodmap
    xorg.xev
    xorg.xmessage
    xorg.xkill
    xorg.xeyes
    xorg.xdpyinfo
    xorg.xwininfo
    xclip
    wmctrl
    scrot
    xscreensaver
    xdotool
    xmobar
    killall
    #termonad-with-packages
    sshfs
    openssl
    gnupg
    keepassxc
    lsof
    virtmanager
    libguestfs
    ascii
    #redshift
    #redshift-plasma-applet
    lftp
    #filezilla
    ranger
    #pcmanfm
    apktool
    appimage-run
    unzip
    p7zip
    ark
    #claws-mail
    # thunderbird
    # firefox
    #chromium
    #google-chrome
    #brave
    #torbrowser
    pinentry
    #texlive.combined.scheme-full
    #pandoc 
    #emacs
    #silver-searcher
    notmuch
    offlineimap
    freetype
    # mupdf
    # nomacs
    #leafpad
    # kwalletcli
    # kdeApplications.kgpg
    # kdeApplications.okular
    # kdeApplications.krdc
    # kdeApplications.marble
    # kdeApplications.kdenlive 
    # gwenview
    # kate
    #hledger
    # hledger-web
    hledger-ui
    #wcalc
    #clementineUnfree
    openh264
    libav
    cmus
    # mplayer
    mpv-with-scripts
    #digikam
    #krita
    #rawtherapee
    #gimp-with-plugins
    #graphviz
    aspellDicts.nl
    aspellDicts.en
    aspellDicts.en-computers
    aspellDicts.en-science
    libreoffice
    git
    git-crypt
    gitAndTools.gitRemoteGcrypt
    gitAndTools.tig
    mercurial
    docker
    docker_compose
    kdiff3-qt5
    jitsi
    html-tidy
    par
    banner
    xsane
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

  # Pinentry.
  programs.gnupg.agent.enable = true;

  programs.tmux = {
    enable = true;
    clock24 = true;
    extraConfig = '' 
      set-option -g prefix C-z
      unbind-key C-b
      bind-key C-z send-prefix
    '';
  };

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
    support32Bit = true;
  };

  # OpenGL configuration.
  hardware.opengl = {
    enable = true;
    driSupport32Bit = true;
    s3tcSupport = true;
  };

  # Enable Redshift.
  services.redshift = {
    enable = true;
    brightness = {
      day = "1";
      night = "0.90";
    };
    temperature = {
      day = 6500;
      night = 3500;
    };
  };
  location.provider = "geoclue2";

  # Power saving settings.
  networking.networkmanager.wifi.powersave = true;

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.layout = "us"; 
  services.xserver.xkbVariant = "altgr-intl"; 
  services.xserver.xkbOptions = "eurosign:e";

  # https://nixos.wiki/wiki/Android
  programs.adb.enable = true;

  # Enable touchpad support.
  services.xserver.libinput.enable = true;

  # Compositor (supposedly fixes screen tearing).
  # services.compton.enable = true;
  
  # Required for screen-lock-on-suspend functionality.
  services.logind.extraConfig = ''
    LidSwitchIgnoreInhibited=False
    HandleLidSwitch=suspend
    HoldoffTimeoutSec=10
  '';
      
  # Graphical environment.
  services.xserver = {
    # Enable the KDE Desktop Environment.
    #displayManager.sddm.enable = true;
    #desktopManager.plasma5.enable = true;

    # Enable xmonad tiling window manager.
    windowManager.xmonad = {
      enable = true;
      enableContribAndExtras = true;
      extraPackages = haskellPackages: [
        haskellPackages.xmonad-contrib
        haskellPackages.xmonad-extras
        haskellPackages.xmonad
      ];
    };
    # https://nixos.wiki/wiki/Using_X_without_a_Display_Manager
    #displayManager.startx.enable = true; # BEWARE: lightdm doesn't start with this enabled.
    displayManager.lightdm.enable = true;
    displayManager.defaultSession = "none+xmonad";

    #displayManager.sessionCommands = with pkgs; lib.mkAfter
    #  ''
    #  xmodmap /path/to/.Xmodmap
    #  '';
  };

 # https://nixos.wiki/wiki/Fonts
  fonts.fonts = with pkgs; [
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    google-fonts
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
    extraGroups = [ "wheel" "docker" "libvirtd" "kvm"
                    "audio" "disk" "video" "networkmanager"
                    "systemd-journal" "lp" "scanner" "adbusers" ];
  };

  users.users.csp = {
    isNormalUser = true;
    extraGroups = [ "audio" "disk" "video" "networkmanager" ];
  };

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "20.03"; # Did you read the comment?
}
