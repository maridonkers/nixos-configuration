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

  networking.hostName = "sapientia"; # Define your hostname.
  networking.networkmanager.enable = true;
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.ens5.useDHCP = true;
  networking.interfaces.wlp3s0.useDHCP = true;

  virtualisation =  {
    docker = {
      enable = true;
      autoPrune.enable = true;
      storageDriver = "btrfs";
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
    tcpdump
    screen
    xorg.xhost
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
    mplayer
    mpv-with-scripts
    cantata
    rawtherapee
    gimp-with-plugins
    git
    git-crypt
    jdk11
    openjfx11
    clojure
    docker
    docker_compose
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
  # networking.firewall.enable = false;

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio = {
    enable = true;
    # support32Bit = true;
  };

  hardware.opengl = {
    enable = true;
    driSupport32Bit = true;
    s3tcSupport = true;
  };

  # Power saving settings.
  services.tlp = {
    enable = true;
    extraConfig = ''
      TLP_DEFAULT_MODE=BAT
      SOUND_POWER_SAVE_ON_AC=1
      WIFI_PWR_ON_AC=on
      # DEVICES_TO_DISABLE_ON_STARTUP="bluetooth wwan"
      DEVICES_TO_DISABLE_ON_STARTUP="wwan"
      CPU_SCALING_GOVERNOR_ON_BAT=powersave
      CPU_SCALING_GOVERNOR_ON_AC=powersave
      CPU_MAX_PERF_ON_BAT=200
      CPU_SCALING_MAX_FREQ_ON_BAT=4400000
      CPU_BOOST_ON_BAT=1
      AHCI_RUNTIME_PM_ON_BAT=auto
    '';
  };
  services.upower.enable = true;
  boot.kernelParams = [
    "workqueue.power_efficient=y"
  ];

  powerManagement = {
    enable = true;
    powertop.enable = true;
  };
  # hardware.bluetooth.powerOnBoot = false;

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

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "19.09"; # Did you read the comment?

}

