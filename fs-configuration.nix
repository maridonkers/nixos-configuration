{ config, pkgs, ... }:

{
  # Root filesystem.
  #
  fileSystems."/" =
    { device = "/dev/disk/by-uuid/ccea459a-2a43-4f1e-8cf5-911350d3cfca";
      fsType = "ext4";
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


  # Enable NTFS support.
  boot.supportedFilesystems = [ "ntfs" ];
}
