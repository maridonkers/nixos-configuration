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
# https://discourse.nixos.org/t/install-nixpkgs-unstable-in-configuration-nix/6462/2
# nix-channel --add https://nixos.org/channels/nixos-unstable nixos-unstable
let unstable = import <nixos-unstable> { config = { allowUnfree = true; }; };
in {
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./fs-configuration.nix
      ./network-configuration.nix
      ./network-samba-configuration.nix
      ./user-configuration.nix
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
  # https://github.com/NixOS/nixpkgs/issues/23926
  # https://discourse.nixos.org/t/what-to-do-with-a-full-boot-partition/2049
  boot.loader.grub.configurationLimit = 3;
  # boot.loader.grub.efiSupport = true;
  # boot.loader.grub.efiInstallAsRemovable = true;
  # boot.loader.efi.efiSysMountPoint = "/boot/efi";
  # Define on which hard drive you want to install Grub.
  boot.loader.grub.device = "/dev/disk/by-id/ata-WDC_WD5000BEKT-60KA9T0_WD-WXG1AA0N9929"; # or "nodev" for efi only
  # boot.loader.grub.extraConfig = "terminal_input_console terminal_output_console";
  
  # Kernel parameters.
  boot.kernelParams = [ "acpi_osi=Linux" ];

  # Reflex binary cache -- https://github.com/reflex-frp/reflex-platform/blob/develop/notes/NixOS.md
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
  #fonts.fontconfig.dpi=96; # TODO obsolete since 21.11

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
    aegisub
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
    boxes
    bpytop
    brave
    btrfs-heatmap
    btrfs-progs
    buttersink
    cachix
    calibre
    castnow
    ccache
    cdrkit
    chromium
    cifs-utils
    clamav
    clementineUnfree
    compsize
    cowsay
    cryptsetup
    darcs
    ddrescue
    dduper
    dict
    digikam
    dmidecode
    docker
    docker_compose
    dos2unix
    dvdbackup
    e2fsprogs
    emacs
    entr
    exa
    exif
    exiv2
    fd
    ffmpeg
    figlet
    file
    filezilla
    firefox
    fortune
    freecad
    freetype
    fzf
    gimp-with-plugins
    git
    git-crypt
    gitAndTools.gitRemoteGcrypt
    gitAndTools.tig
    gnumake
    gnupg
    #google-chrome
    grab-site
    graphviz
    gwenview
    handbrake
    hashcat
    hashcat-utils
    hcxtools
    hddtemp
    hdparm
    heimdall-gui
    highlight
    hledger
    hledger-ui
    hlint
    html-tidy
    htop
    imagemagick
    irccloud
    #jdk11
    #jitsi # (use nix-env install under account for this)
    kate
    kcalc
    kdenlive
    kdiff3-qt5
    keepassxc
    killall
    kismet
    #krita
    ktorrent
    ledger
    lf
    lftp
    # libav (this is marked as insecure?)
    librecad
    libreoffice
    lshw
    lsof
    lsscsi
    lynis
    mdcat
    mercurial
    metasploit
    microcodeIntel
    mkvtoolnix
    mpack
    mpv-with-scripts
    mupdf
    nix-index
    nix-prefetch-scripts
    nmap
    nomacs
    notmuch
    offlineimap
    okular
    opencascade
    openh264
    openscad
    openssl
    opera
    p7zip
    pandoc
    paperwork
    par
    pavucontrol
    pciutils
    pcmanfm
    #pinentry
    pkg-config
    pmutils
    poppler_utils
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
    slrn
    smartmontools
    smem
    smemstat
    snapper
    sourceHighlight
    sshfs
    subdl
    subtitleeditor
    sysstat
    tcpdump
    telnet
    termonad
    texlive.combined.scheme-full
    thunderbird
    tree
    ums
    unzip
    usbutils
    vim
    virtmanager
    vlc
    vivaldi
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

      # https://gist.github.com/william8th/faf23d311fc842be698a1d80737d9631
      # https://www.seanh.cc/2020/12/30/how-to-make-tmux's-windows-behave-like-browser-tabs/#:~:text=Key%20bindings&text=conf%20file%20to%20get%20browser,and%20C%2DS%2DTab%20in%20tmux.
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
  # services.xserver.xkbOptions = "compose:sclk";
  services.xserver.xkbOptions = "compose:caps,shift:both_capslock,eurosign:e";

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

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "20.03"; # Did you read the comment?
}
