{ config, pkgs, pkgs-unstable, ... }:

{
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.mdo = {
    isNormalUser = true;
    uid = 1000;
    extraGroups = [ "wheel" "docker" "libvirtd" "kvm"
                    "audio" "disk" "video" "network"
                    "systemd-journal" "lp" "scanner" "adbusers" ];

    packages = 
    [
      pkgs.aegisub
      # pkgs.android-studio # broken?
      pkgs.android-file-transfer
      pkgs.apktool
      #pkgs.appimage-run
      pkgs.aria
      pkgs.ascii
      pkgs.aspellDicts.en
      pkgs.aspellDicts.en-computers
      pkgs.aspellDicts.en-science
      pkgs.aspellDicts.nl
      pkgs.awscli2
      pkgs.aws-sam-cli
      pkgs.bandwhich
      pkgs.banner
      pkgs.bat
      pkgs.boxes
      pkgs.brave
      pkgs.btrfs-heatmap
      pkgs.btrfs-progs
      #pkgs.cabal-install
      #pkgs.cabal2nix
      pkgs.calibre
      pkgs.cbonsai
      pkgs.ccache
      pkgs.chromium
      pkgs.cmatrix
      pkgs.cowsay
      pkgs.dbmate
      pkgs.dict
      pkgs.digikam
      pkgs.dillo
      pkgs.direnv
      pkgs.docker
      pkgs.docker-compose
      #pkgs-unstable.emacs
      pkgs.emacs
      pkgs.ecl
      pkgs.exif
      pkgs.exiv2
      pkgs.feh
      pkgs.ffmpeg
      pkgs.figlet
      pkgs.filezilla
      pkgs.fortune
      pkgs.freecad
      pkgs.freetube
      pkgs.fzf
      #pkgs.gambit
      pkgs.gcc_multi
      #pkgs.gerbil
      #pkgs.ghc
      pkgs.gimp-with-plugins
      pkgs.go
      pkgs.graphviz
      pkgs.handbrake
      pkgs.hashcat
      pkgs.hashcat-utils
      pkgs.hcxtools
      pkgs.heimdall-gui
      pkgs.highlight
      pkgs.hledger
      pkgs.hledger-ui
      pkgs.hlint
      pkgs.html-tidy
      pkgs.imagemagick
      pkgs.ipfs
      pkgs.python310Packages.ipython 
      pkgs.irccloud
      pkgs.isync
      pkgs.jellyfin-media-player
      pkgs.jp2a
      pkgs.jq
      pkgs.jujutsu
      pkgs.just
      pkgs.kate
      pkgs.kcalc
      pkgs.kdenlive
      pkgs.kdiff3
      pkgs.keepassxc
      pkgs.kismet
      pkgs.koreader
      pkgs.lazygit
      pkgs.ledger
      pkgs.librecad
      pkgs.libreoffice
      pkgs.librewolf
      pkgs.libstemmer
      pkgs.lynx
      pkgs.mdcat
      pkgs.mercurial
      pkgs.metasploit
      pkgs.mkvtoolnix
      pkgs.mpv
      pkgs.mpvScripts.sponsorblock
      pkgs.mpvScripts.quality-menu
      pkgs.musikcube
      pkgs.mutt
      pkgs.neovim
      pkgs.neovim-qt
      pkgs.nomacs
      pkgs.notmuch
      #pkgs.nyxt
      #pkgs.offlineimap
      pkgs.okular
      pkgs.ollama
      pkgs.ookla-speedtest
      pkgs.opencascade-occt
      pkgs.openscad
      #pkgs.opera
      pkgs.oterm
      pkgs.pandoc
      pkgs.paperwork
      pkgs.par
      pkgs.pcmanfm
      pkgs.pcre
      pkgs.plantuml-c4
      pkgs.poppler_utils
      pkgs.python3
      #pkgs-unstable.racket
      #pkgs.racket
      pkgs.rawtherapee
      pkgs.ripgrep
      pkgs.rustup
      pkgs.sabnzbd
      pkgs.silver-searcher
      pkgs.slrn
      pkgs.sourceHighlight
      pkgs.sqlite
      #pkgs.stack
      pkgs.subdl
      pkgs.subtitleeditor
      pkgs.sweethome3d.application
      pkgs.texliveMinimal
      pkgs.thunderbird
      pkgs.tokei
      pkgs.tor-browser-bundle-bin
      pkgs.translate-shell
      pkgs.urlscan
      pkgs.virt-manager
      #pkgs.vivaldi
      #pkgs.vivaldi-ffmpeg-codecs
      pkgs.vlc
      pkgs.vym
      #pkgs.wapm-cli # 24.05 missing package
      pkgs.wasmer
      pkgs.wcalc
      pkgs.weather
      #pkgs.wine
      #pkgs.winetricks
      pkgs.yt-dlp
      pkgs.zathura
      pkgs.zellij
    ]; 
  };

  users.users.csp = {
    isNormalUser = true;
    uid = 1001;
    extraGroups = [ "audio" "disk" "video" ];

    packages = 
    [
      pkgs.libreoffice
      pkgs.librewolf
    ]; 
  };

  # Trusted users (IHP)
  nix.settings.trusted-users = [ "root" "@wheel" ];
}

