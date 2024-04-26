{ config, pkgs, ... }:

{
  # Root filesystem.
  #
  fileSystems."/" =
    { device = "/dev/disk/by-uuid/8148bec1-bb21-4202-bf99-8ad3c33d8c32";
      fsType = "ext4";
    };

  # Boot filesystem.
  #
  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/6e2a0881-0a29-43e6-a8ed-44e1fa8909e6";
      fsType = "ext4";
    };

  # Swap partition.
  #
  swapDevices =
    [ { device = "/dev/disk/by-uuid/493ad088-5b50-4aae-95b4-381a52292946"; }
    ];

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

  # Enable NTFS support.
  boot.supportedFilesystems = [ "ntfs" ];
}
