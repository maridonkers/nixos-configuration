{ config, pkgs, ... }:

{
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.mdo = {
    isNormalUser = true;
    uid = 1000;
    extraGroups = [ "wheel" "docker" "libvirtd" "kvm"
                    "audio" "disk" "video" "network"
                    "systemd-journal" "lp" "scanner" "adbusers" ];

    packages = with pkgs; 
    [
      aegisub
      # android-studio # broken?
      android-file-transfer
      apktool
      appimage-run
      aria
      ascii
      aspellDicts.en
      aspellDicts.en-computers
      aspellDicts.en-science
      aspellDicts.nl
      awscli2
      aws-sam-cli
      bandwhich
      banner
      bat
      boxes
      brave
      btrfs-heatmap
      btrfs-progs
      cabal-install
      cabal2nix
      calibre
      cbonsai
      ccache
      chromium
      cmatrix
      conda
      cowsay
      dbmate
      dict
      digikam
      direnv
      docker
      docker-compose
      emacs
      exif
      exiv2
      feh
      ffmpeg
      figlet
      filezilla
      fortune
      freecad
      freetube
      fzf
      gcc_multi
      ghc
      gimp-with-plugins
      go
      graphviz
      handbrake
      hashcat
      hashcat-utils
      hcxtools
      heimdall-gui
      highlight
      hledger
      hledger-ui
      hlint
      html-tidy
      hydra-check
      imagemagick
      ipfs
      python310Packages.ipython 
      irccloud
      isync
      jp2a
      jq
      jujutsu
      just
      kate
      kcalc
      kdenlive
      kdiff3
      keepassxc
      kismet
      koreader
      lazygit
      ledger
      librecad
      libreoffice
      librewolf
      libstemmer
      lynx
      mdcat
      mercurial
      metasploit
      mkvtoolnix
      mpv
      mpvScripts.sponsorblock
      mpvScripts.quality-menu
      musikcube
      mutt
      neovim
      neovim-qt
      nomacs
      notmuch
      offlineimap
      okular
      ookla-speedtest
      opencascade-occt
      openscad
      opera
      pandoc
      paperwork
      par
      pcmanfm
      pcre
      plantuml-c4
      poppler_utils
      python3
      rawtherapee
      ripgrep
      rustup
      sabnzbd
      silver-searcher
      slrn
      sourceHighlight
      sqlite
      stack
      subdl
      subtitleeditor
      texliveMinimal
      thunderbird
      tokei
      tor-browser-bundle-bin
      translate-shell
      urlscan
      virt-manager
      vivaldi
      vivaldi-ffmpeg-codecs
      vlc
      vym
      wapm-cli
      wasmer
      wcalc
      weather
      #wine
      #winetricks
      yt-dlp
      zathura
      zellij
    ]; 
  };

  users.users.csp = {
    isNormalUser = true;
    uid = 1001;
    extraGroups = [ "audio" "disk" "video" ];

    packages = with pkgs; 
    [
      libreoffice
      librewolf
    ]; 
  };

  # Trusted users (IHP)
  nix.settings.trusted-users = [ "root" "@wheel" ];
}

