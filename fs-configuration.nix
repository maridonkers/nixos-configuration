{ config, pkgs, ... }:

{
  # Root filesystem.
  #
  fileSystems."/" =
    { device = "/dev/disk/by-uuid/8be69c44-b987-4eb8-a1b6-c67ed80c9512";
      fsType = "btrfs";
      options = [ "noatime" "space_cache" ];
    };

  # Boot filesystem.
  #
  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/bc62f488-7c99-4a12-816c-1aa671557a9d";
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
    [ { device = "/dev/disk/by-uuid/99be5bc9-fac4-4386-83c0-63632edef9dc"; }
    ];
}
