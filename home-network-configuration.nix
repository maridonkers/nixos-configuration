{ config, pkgs, ... }:

{
  networking.networkmanager.enable = true;
  #networking.networkmanager.wifi.powersave = false;

  networking.hostName = "sapientia"; # Define your hostname.
  #networking.extraHosts = "127.0.0.1 server";
  # networking.nameservers = [ "1.1.1.1" "9.9.9.9" ];
  networking.wireless.enable = false;  # Wireless support via wpa_supplicant.

  #networking.wireless.networks = {
  #  "TMNL-540B11" = {
  #    psk = "R7SNHWM4Q9BRXDA7";
  #  };
  #  #free.wifi = {};            # Public wireless network
  #};
  networking.wireless.userControlled = {
    enable = true;
    group = "network";
  };

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [ 22 80 445 139 3443 4100 58050 ];
  networking.firewall.allowedUDPPorts = [ 137 138 ];
  #networking.firewall.allowedTCPPorts = [ 22 ];
  #networking.firewall.allowedUDPPorts = [ ];
  networking.firewall.enable = true;

  # minidlna service
  #services.minidlna.enable = true;
  #services.minidlna.announceInterval = 60;
  #services.minidlna.friendlyName = "Laptop";
  #services.minidlna.mediaDirs = ["V,/home/mdo/Movies/" "V,/run/media/mdo/"];

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.ens5.useDHCP = true;
  networking.interfaces.wlp3s0.useDHCP = true;

  # https://github.com/NixOS/nixpkgs/issues/49630
  # (the suggested --load-media-router-component-extension=1 appears to be no longer required.)
  #services.avahi.enable = true; # see above

  #services.openvpn.servers = {
  #  us1  = {
  #    config = '' config /root/vpn/us1-mdonkers.ovpn '';
  #  };
  #  us2  = {
  #    config = '' config /root/vpn/us2-mdonkers.ovpn '';
  #  };

    #homeVPN    = { config = '' config /root/nixos/openvpn/homeVPN.conf ''; };
    #serverVPN  = { config = '' config /root/nixos/openvpn/serverVPN.conf ''; };
  #};
}

