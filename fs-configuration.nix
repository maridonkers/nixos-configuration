{ config, pkgs, ... }:

{
  # Root filesystem.
  #
  fileSystems."/" =
    { device = "/dev/disk/by-uuid/2fb30582-8705-4641-93fd-b3515a597e41";
      fsType = "ext4";
    };

  # Boot filesystem.
  #
  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/c62c9d4d-a341-4a77-8457-186dab77db54";
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
    [ { device = "/dev/disk/by-uuid/52ec5fd2-5ec0-4758-bc5e-eaa21f8e6e6d"; }
    ];

  # Enable NTFS support.
  boot.supportedFilesystems = [ "ntfs" ];
}
