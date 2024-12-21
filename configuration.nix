# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
#
# https://nixos.org/nixos/manual/index.html
# https://nixos.org/nixos/options.html
# https://nixos.wiki/wiki/Configuration_Collection
#
# https://status.nixos.org/
# https://discourse.nixos.org/t/tips-tricks-for-nixos-desktop/28488
#
# Command examples:
# o nix flake update
# o nixos-rebuild --flake .#sapientia switch 
# o nixos-rebuild --flake .#sapientia dry-activate
# o nixos-rebuild --flake .#sapientia dry-build
#

{ config, pkgs, pkgs-unstable, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./fs-configuration.nix
      #./travel-network-configuration.nix
      ./home-network-configuration.nix
      ./user-configuration.nix
      ./env-configuration.nix
      #./vpn-configuration.nix
      ./cachix.nix
    ];

  # nixos-rebuild --flake .#sapientia switch
  nix = {
    #package = pkgs.nixFlakes;
    package = pkgs.nixVersions.stable;
    extraOptions = ''
        experimental-features = nix-command flakes
    '';
  };

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
  # [OBSOLETE]boot.loader.grub.version = 2;
  # https://github.com/NixOS/nixpkgs/issues/23926
  # https://discourse.nixos.org/t/what-to-do-with-a-full-boot-partition/2049
  boot.loader.grub.configurationLimit = 3;
  # boot.loader.grub.efiSupport = true;
  # boot.loader.grub.efiInstallAsRemovable = true;
  # boot.loader.efi.efiSysMountPoint = "/boot/efi";
  # Define on which hard drive you want to install Grub.
  boot.loader.grub.device = "/dev/disk/by-id/ata-TOSHIBA_MQ01ABD050V_Z4K5SACFS"; # or "nodev" for efi only
  # boot.loader.grub.extraConfig = "terminal_input_console terminal_output_console";
  
  # Kernel parameters.
  boot.kernelParams = [ "acpi_osi=Linux" ];

  # https://nixos.wiki/wiki/Flakes
  # https://mhwombat.codeberg.page/nix-book/
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # https://github.com/obsidiansystems/obelisk/#installing-obelisk
  # nix.binaryCaches = [ "https://nixcache.reflex-frp.org" ];
  # nix.binaryCachePublicKeys = [ "ryantrinkle.com-1:JJiAKaRv9mWgpVAz8dwewnZe0AzzEAzPkagE9SP5NWI=" ];

  # https://github.com/Mic92/nix-ld
  programs.nix-ld.enable = true;

  programs.nix-ld.libraries = with pkgs; [
    stdenv.cc.cc
    fuse3
    alsa-lib
    at-spi2-atk
    at-spi2-core
    atk
    cairo
    cups
    curl
    dbus
    expat
    fontconfig
    freetype
    gdk-pixbuf
    glib
    gtk3
    libGL
    libappindicator-gtk3
    libdrm
    libnotify
    #libpulseaudio
    libuuid
    libusb1
    xorg.libxcb
    libxkbcommon
    mesa
    nspr
    nss
    nwjs
    pango
    pipewire
    systemd
    icu
    openssl
    xorg.libX11
    xorg.libXScrnSaver
    xorg.libXcomposite
    xorg.libXcursor
    xorg.libXdamage
    xorg.libXext
    xorg.libXfixes
    xorg.libXi
    xorg.libXrandr
    xorg.libXrender
    xorg.libXtst
    xorg.libxkbfile
    xorg.libxshmfence
    zlib
  ];

  programs.wireshark = {
    enable = true;
    package = pkgs.wireshark;
  };

  # Disable automatic refresh of ClamAV signatures database (do this manually).
  services.clamav = {
    # daemon.enable = true;
    updater.enable = true;
  };

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";
  
  # Virtualization functionality.
  virtualisation =  {
    # Android emulator - https://nixos.wiki/wiki/WayDroid
    #waydroid.enable = true; # requires Wayland... (I use X)

    # Docker host. The --iptables=false makes sure that Docker doesn't alter
    # the firewall (as a default containers should no be accessible from outside).
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

  # Select internationalisation properties.
  i18n = {
    #consoleFont = "Lat2-Terminus16";
    #consoleKeyMap = "us";
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = { LC_MESSAGES = "en_US.UTF-8"; LC_TIME = "nl_NL.UTF-8"; };
  };

  console = {
    font = "Lat1-Terminus16";
    keyMap = "us";
  };

  # Set your time zone.
  time.timeZone = "Europe/Amsterdam";

  # Allow packages with non-free licenses.
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # `nix search wget`
  environment.systemPackages = [
    #pkgs.appimage-run
    pkgs.arandr
    pkgs.ark
    #pkgs.bandwhich
    pkgs.banner
    pkgs.beep
    pkgs.binutils-unwrapped
    pkgs.bottom
    pkgs.brotli
    pkgs.btrfs-assistant
    pkgs.btrfs-heatmap
    pkgs.btrfs-progs
    pkgs.cachix
    #pkgs.castnow
    pkgs.ccache
    pkgs.cdrkit
    pkgs.chromium
    pkgs.cifs-utils
    pkgs.compsize
    pkgs.cryptsetup
    pkgs.darcs
    pkgs.ddrescue
    pkgs.dig
    pkgs.digikam
    pkgs.dmidecode
    pkgs.dos2unix
    pkgs.duperemove
    pkgs.dvdbackup
    pkgs.e2fsprogs
    pkgs.entr
    pkgs.eza
    pkgs.exif
    pkgs.exiv2
    pkgs.fd
    pkgs.file
    pkgs.freetype
    pkgs.git
    pkgs.git-crypt
    pkgs.git-lfs
    pkgs.gitAndTools.gitRemoteGcrypt
    pkgs.gitAndTools.tig
    pkgs.gnumake
    pkgs.gnupg
    pkgs.hddtemp
    pkgs.hdparm
    pkgs.html-tidy
    pkgs.htop
    pkgs.hydra-check
    pkgs.iotop
    pkgs.killall
    pkgs.lftp
    pkgs.lm_sensors
    pkgs.lshw
    pkgs.lsof
    pkgs.lsscsi
    pkgs.lynis
    pkgs.microcodeIntel
    pkgs.mkvtoolnix
    pkgs.mpack
    pkgs.neofetch
    pkgs.nix-index
    pkgs.nix-prefetch-scripts
    pkgs.nmap
    pkgs.openh264
    pkgs.openssl
    pkgs.openvpn
    pkgs.p7zip
    pkgs.pass
    pkgs.pavucontrol
    pkgs.pciutils
    #pkgs-unstable.pkg-config
    pkgs.pmutils
    pkgs.procs
    # pkgs.psensor # 24.11 removed because unmaintained
    pkgs.psmisc
    pkgs.pstree
    pkgs.pv
    pkgs.ranger
    pkgs.rclone
    pkgs.rename
    pkgs.restic
    pkgs.rmlint
    pkgs.safecopy
    pkgs.screen
    pkgs.scrot
    pkgs.skim
    pkgs.smartmontools
    pkgs.smem
    pkgs.smemstat
    pkgs.snapper
    pkgs.socat
    pkgs.sutils
    pkgs.sshfs
    pkgs.sysstat
    pkgs.tcpdump
    pkgs.inetutils
    pkgs.tree
    pkgs.ums
    pkgs.unzip
    pkgs.usbutils
    pkgs.vim
    pkgs.virt-manager
    pkgs.vulnix
    pkgs.w3m
    pkgs.wget
    pkgs.wirelesstools
    pkgs.wmctrl
    pkgs.wpa_supplicant
    pkgs.xclip
    pkgs.xdotool
    pkgs.xmobar
    pkgs.xorg.xdpyinfo
    pkgs.xorg.xev
    pkgs.xorg.xeyes
    pkgs.xorg.xhost
    pkgs.xorg.xinit
    pkgs.xorg.xkill
    pkgs.xorg.xmessage
    pkgs.xorg.xmodmap
    pkgs.xorg.xwininfo
    pkgs.xsane
    pkgs.xsel
    pkgs.zip
  ];

  #nixpkgs.config.permittedInsecurePackages = [
  #    "ffmpeg-2.8.17"
  #];

  # Enable nix-direnv
  programs.direnv.enable = true;

  services.fwupd.enable = true;
  # fwupdmgr[231212]: WARNING: UEFI firmware can not be updated in legacy BIOS mode
  # fwupdmgr[231212]: See https://github.com/fwupd/fwupd/wiki/PluginFlag:legacy-bios for more information.
  # TODO Has no effect on the error message?
  #services.fwupd.daemonSettings.DisabledPlugins = [ "test" " invalid" "bios" ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = { enable = true; enableSSHSupport = true; };

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;
  services.openssh = {
    enable = true;

    # Only pubkey auth
    settings = {
      PasswordAuthentication = false;
      # challengeResponseAuthentication = false; # 22.05 renamed to services.openssh.kbdInteractiveAuthentication
      KbdInteractiveAuthentication = false;
    };
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
    #extraConfig = '' 
    #  set-option -g prefix C-x
    #  unbind-key C-b
    #  bind-key C-x send-prefix
    #'';
  };

  # Printing. Enable CUPS to print documents.
  # https://nixos.wiki/wiki/Printing
  services.printing.enable = true;
  services.printing.logLevel = "none";
  services.printing.drivers = with pkgs; [ hplipWithPlugin ];

  # Scanning with sane.
  hardware.sane.enable = true;
  hardware.sane.extraBackends = with pkgs; [ hplipWithPlugin ];

  # Enable sound.
  #sound.enable = true;
  #hardware.pulseaudio = {
  #  enable = true;
  #  support32Bit = true;
  #};

  # Disable Bluetooth (my notebook doesn't have it).
  hardware.bluetooth.enable = false;
  
  # OpenGL configuration.
  # https://discourse.nixos.org/t/trouble-getting-hardware-video-decoding-in-chrome-based-browsers-with-amd-gpu/25206/6
  hardware.graphics.enable = true;
  #hardware.opengl = {
    #enable = true;
    #driSupport = true;
    #driSupport32Bit = true;
  #};

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

  # Enable the grim reaper.
  services.xserver.enableCtrlAltBackspace = true;

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.xkb.layout = "us"; 
  # services.xserver.xkbVariant = "altgr-intl"; 
  #services.xserver.xkbOptions = "eurosign:e";
  # services.xserver.xkbOptions = "compose:caps,shift:both_capslock";
  # services.xserver.xkbOptions = "compose:sclk";
  services.xserver.xkb.options = "compose:caps,shift:both_capslock,eurosign:e";

  # Legacy video driver for NVIDIA GeForce 335M (?) support.
  #services.xserver.videoDrivers = [ "nvidiaLegacy304" ];

  # Enable slock with suid set.
  programs.slock.enable = true;

  # https://nixos.wiki/wiki/Android
  programs.adb.enable = true;

  # Enable touchpad support by default.
  services.libinput.enable = true;

  # Compositor (supposedly fixes screen tearing).
  # services.compton.enable = true;
  
  # Required for screen-lock-on-suspend functionality.
  # RuntimeDirectorySize: https://discourse.nixos.org/t/run-usr-id-is-too-small/4842
  services.logind.extraConfig = ''
    LidSwitchIgnoreInhibited=False
    HandleLidSwitch=suspend
    HoldoffTimeoutSec=10
    RuntimeDirectorySize=3G
  '';

  # https://www.reddit.com/r/NixOS/comments/fkrbd1/options_for_power_managment/
  # https://wiki.archlinux.org/title/Display_Power_Management_Signaling
  # To disable screen off when monitor has difficulty to escape darkness.
  #environment.extraInit = ''
  #  xset s off -dpms 2>&1 > /dev/null
  #'';
      
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
      #config = builtins.readFile /etc/nixos/xmonad/xmonad.hs
      extraPackages = haskellPackages: [
        haskellPackages.xmonad-contrib
        haskellPackages.xmonad-extras
        haskellPackages.xmonad
      ];
    };


    # Enable i3 tiling window manager.
    #windowManager.i3 = {
    #  enable = true;
    #  extraPackages = with pkgs; [
    #    dmenu
    #    i3status
    #    i3lock
    #    i3blocks
    #  ];
    #};

    # https://nixos.wiki/wiki/Using_X_without_a_Display_Manager
    #displayManager.startx.enable = true; # BEWARE: lightdm doesn't start with this enabled.
    displayManager.lightdm.enable = true;

    #displayManager.sessionCommands = with pkgs; lib.mkAfter
    #  ''
    #  xmodmap /path/to/.Xmodmap
    #  '';
  };
  #services.displayManager.defaultSession = "none+xmonad";
  #services.displayManager.defaultSession = "none+i3";
  services.displayManager.defaultSession = "none+xmonad";
  
 # https://nixos.wiki/wiki/Fonts
  fonts.packages = with pkgs; [
    hack-font
    noto-fonts
    noto-fonts-cjk-sans
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
  system.stateVersion = "24.11"; # Did you read the comment?
}
