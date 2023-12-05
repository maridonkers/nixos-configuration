{ config, pkgs, ... }:

{
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.mdo = {
    isNormalUser = true;
    uid = 1000;
    extraGroups = [ "wheel" "docker" "libvirtd" "kvm"
                    "audio" "disk" "video" "network"
                    "systemd-journal" "lp" "scanner" "adbusers" ];
  };

  users.users.csp = {
    isNormalUser = true;
    uid = 1001;
    extraGroups = [ "audio" "disk" "video" ];
  };

  # Trusted users (IHP)
  nix.settings.trusted-users = [ "root" "@wheel" ];
}

