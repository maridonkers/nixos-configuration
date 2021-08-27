# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
#
# https://nixos.org/nixos/manual/index.html
# https://nixos.org/nixos/options.html
# https://nixos.wiki/wiki/Configuration_Collection
#

{ config, pkgs, ... }:

# This (unstable) is only applicable when the unstable channel is installed (which is optional).
let unstable = import <nixos-unstable> { config = { allowUnfree = true; }; };
in {
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./fs-configuration.nix
      ./network-configuration.nix
      ./env-configuration.nix
      ./vpn-configuration.nix
      ./cachix.nix
    ];

  # Disable automatic storage optimization (computer needs to be responsive at all times).
  # https://nixos.wiki/wiki/Storage_optimization
  #nix.gc = {
  #  automatic = true;
  #  dates = "weekly";
  #  options = "--delete-older-than 31d";
  #};

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
  boot.kernelParams = [ "acpi_osi=Linux" ];

  # Obelisk/Reflex -- https://github.com/obsidiansystems/obelisk
  nix = {
    binaryCaches = [
      "https://nixcache.reflex-frp.org"
    ];
    binaryCachePublicKeys = [
      "ryantrinkle.com-1:JJiAKaRv9mWgpVAz8dwewnZe0AzzEAzPkagE9SP5NWI="
    ];
  };

  programs.wireshark = {
    enable = true;
    package = pkgs.wireshark;
  };

  # Disable automatic refresh of ClamAV signatures database (do this manually).
  #services.clamav = {
  #  # daemon.enable = true;
  #  updater.enable = true;
  #};

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

    # To be able to run Android applications.
    #anbox.enable = true; #  TODO anbox broken in 21.05

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
    android-file-transfer
    apktool
    appimage-run
    arandr
    ark
    ascii
    aspellDicts.en
    aspellDicts.en-computers
    aspellDicts.en-science
    aspellDicts.nl
    banner
    beep
    binutils-unwrapped
    bpytop
    btrfs-progs
    cabal-install
    cabal2nix
    cachix
    calibre
    castnow
    ccache
    cdrkit
    chromium
    cifs-utils
    clamav
    clementineUnfree
    cowsay
    cryptsetup
    darcs
    digikam
    #discord (use nix-env install under account for this)
    dmidecode
    docker
    docker_compose
    dos2unix
    e2fsprogs
    emacs
    entr
    exif
    ffmpeg
    figlet
    file
    filezilla
    firefox
    fortune
    freetype
    ghc
    ghcid
    gimp-with-plugins
    git
    git-crypt
    gitAndTools.gitRemoteGcrypt
    gitAndTools.tig
    gnumake
    gnupg
    #google-chrome
    graphviz
    gwenview
    handbrake
    hddtemp
    hdparm
    heimdall-gui
    hledger
    hledger-ui
    hlint
    html-tidy
    htop
    imagemagick
    #jdk11
    #jitsi # (use nix-env install under account for this)
    kate
    kdenlive
    #kdiff3-qt5
    keepassxc
    killall
    kismet
    #krita
    ledger
    lftp
    # libav (this is marked as insecure?)
    libreoffice
    lshw
    lsof
    lsscsi
    lynis
    mercurial
    metasploit
    microcodeIntel
    mkvtoolnix
    mpv-with-scripts
    #mupdf
    nix-index
    nix-prefetch-scripts
    nmap
    nodejs
    #nomacs
    notmuch
    okular
    offlineimap
    openh264
    openssl
    ormolu
    p7zip
    pandoc
    paperwork
    par
    pciutils
    #pinentry
    pkg-config
    pmutils
    psmisc
    pstree
    python3
    ranger
    rawtherapee
    rclone
    restic
    rmlint
    sabnzbd
    screen
    scrot
    silver-searcher
    smartmontools
    snapper
    sshfs
    stack
    subdl
    subtitleeditor
    tcpdump
    telnet
    texlive.combined.scheme-full
    thunderbird
    #tmux  # TODO tmux server crashes after a while...
    tree
    ums
    unzip
    usbutils
    vim
    virtmanager
    vlc
    wcalc
    wget
    wirelesstools
    wmctrl
    wmctrl
    wpa_supplicant
    xclip
    xdotool
    xlockmore
    xmobar
    #xmonad-with-packages
    xorg.xdpyinfo
    xorg.xev
    xorg.xeyes
    xorg.xhost
    xorg.xinit
    xorg.xkill
    xorg.xmessage
    xorg.xmodmap
    xorg.xwininfo
    xsane
    yara
    youtube-dl
    #zoom-us # (use nix-env install under account for this)
  ];

  #nixpkgs.config.permittedInsecurePackages = [
  #    "ffmpeg-2.8.17"
  #];


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

  # Disable Bluetooth (my notebook doesn't have it).
  hardware.bluetooth.enable = false;
  
  # OpenGL configuration.
  hardware.opengl = {
    enable = true;
    driSupport32Bit = true;
  };

  # Enable Redshift.
  #services.redshift = {
  #  enable = true;
  #  brightness = {
  #    day = "1";
  #    night = "0.90";
  #  };
  #  temperature = {
  #    day = 6500;
  #    night = 3500;
  #  };
  #};
  location.provider = "geoclue2";

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.layout = "us"; 
  # services.xserver.xkbVariant = "altgr-intl"; 
  #services.xserver.xkbOptions = "eurosign:e";
  # services.xserver.xkbOptions = "compose:caps,shift:both_capslock";
  services.xserver.xkbOptions = "compose:sclk";

  # Legacy video driver for NVIDIA GeForce 335M (?) support.
  # TODO Package is marked as broken in NixOS stable 20.09 (...)
  #services.xserver.videoDrivers = [ "nvidiaLegacy304" ];

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
    #desktopManager = {
    #  xterm.enable = false;
    #  xfce.enable = true;
    #};
    #displayManager.defaultSession = "xfce";

    # Enable the KDE Desktop Environment.
    displayManager.sddm.enable = true;
    desktopManager.plasma5.enable = true;

    # Enable xmonad tiling window manager.
    # windowManager.xmonad = {
    #   enable = true;
    #   enableContribAndExtras = true;
    #   extraPackages = haskellPackages: [
    #     haskellPackages.xmonad-contrib
    #     haskellPackages.xmonad-extras
    #     haskellPackages.xmonad
    #   ];
    # };

    # https://nixos.wiki/wiki/Using_X_without_a_Display_Manager
    #displayManager.startx.enable = true; # BEWARE: lightdm doesn't start with this enabled.
    #displayManager.lightdm.enable = true;
    #displayManager.defaultSession = "none+xmonad";

    #displayManager.sessionCommands = with pkgs; lib.mkAfter
    #  ''
    #  xmodmap /path/to/.Xmodmap
    #  '';
  };

 # https://nixos.wiki/wiki/Fonts
  fonts.fonts = with pkgs; [
    hack-font
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
                    "audio" "disk" "video" "network"
                    "systemd-journal" "lp" "scanner" "adbusers" ];
  };

  users.users.csp = {
    isNormalUser = true;
    extraGroups = [ "audio" "disk" "video" ];
  };

  # Trusted users (IHP)
  nix.trustedUsers = [ "root" "mdo" ];

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "20.03"; # Did you read the comment?
}
