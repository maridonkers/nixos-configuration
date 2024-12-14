{ config, pkgs, ... }:

{
  # Root filesystem.
  #
  fileSystems."/" =
    { device = "/dev/disk/by-label/nixos";
      fsType = "ext4";
    };

  # Boot filesystem.
  #
  fileSystems."/boot" =
    { device = "/dev/disk/by-label/boot";
      fsType = "ext4";
    };

  # Encrypted partition.
  #
  boot.initrd.luks.devices."cr-home" = {
      device = "/dev/disk/by-uuid/75236c0e-cad4-43a7-986c-a5f82f68cf65";
    };

  fileSystems."/home" =
    { device = "/dev/mapper/cr-home";
      fsType = "btrfs";
      options = [ "noatime" "space_cache" ];
    };

  # Swap partition.
  #
  swapDevices =
    [ { device = "/dev/disk/by-label/swap"; }
    ];


  # Enable NTFS support.
  boot.supportedFilesystems = [ "ntfs" ];
}
