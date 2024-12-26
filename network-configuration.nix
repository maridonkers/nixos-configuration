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

  # Open ports in the firewall (use SSH port forwarding for the rest).
  networking.firewall.allowedTCPPorts = [ 22 ];
  networking.firewall.allowedUDPPorts = [ ];
  networking.firewall.enable = true;

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.ens5.useDHCP = true;
  networking.interfaces.wlp3s0.useDHCP = true;

  # Enable Jellyfin server
  services.jellyfin = {
    enable = true;

    # HOME
    # openFirewall = true;

    # TRAVEL
    openFirewall = false;
  };
  environment.systemPackages = [
    pkgs.jellyfin
    pkgs.jellyfin-web
    pkgs.jellyfin-ffmpeg
  ];
}

