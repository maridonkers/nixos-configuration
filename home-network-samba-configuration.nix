{ config, pkgs, ... }:

{
  # Samba service
  # - https://nixos.wiki/wiki/Samba
  # - https://gist.github.com/vy-let/a030c1079f09ecae4135aebf1e121ea6

  services.samba = {
    enable = true;
    securityType = "user"; # use smbpasswd -a mdo to set Samba password

    extraConfig = ''
      workgroup = WORKGROUP
      server string = smbnix
      netbios name = smbnix
      security = user 
      browseable = no
      #use sendfile = yes
      max protocol = smb2
      hosts allow = 192.168.1.  192.168.122.  localhost
      hosts deny = 0.0.0.0/0
      guest account = nobody
      map to guest = bad user
    '';
    shares = {
      homes = {
        browseable = "no";  # note: each home will be browseable; the "homes" share will not.
        "read only" = "no";
        "guest ok" = "no";
      };
      movies = {
        path = "/mnt/movies";
        browseable = "yes";
        "read only" = "yes";
        "guest ok" = "no";
        writeable = "no";
#        "create mask" = "0644";
#        "directory mask" = "0755";
        "valid users" = "mdo";
        "force user" = "mdo";
        "force group" = "users";
      };
      new = {
        path = "/home/mdo/Movies";
        browseable = "yes";
        "read only" = "yes";
        "guest ok" = "no";
        writeable = "no";
#        "create mask" = "0644";
#        "directory mask" = "0755";
        "valid users" = "mdo";
        "force user" = "mdo";
        "force group" = "users";
      };
#      private = {
#        path = "/mnt/Shares/Private";
#        browseable = "yes";
#        "read only" = "no";
#        "guest ok" = "no";
#        "create mask" = "0644";
#        "directory mask" = "0755";
#        "force user" = "username";
#        "force group" = "groupname";
#      };
    };
  };

  # mDNS
  #
  # This part may be optional for your needs, but I find it makes browsing in Dolphin easier,
  # and it makes connecting from a local Mac possible.
  services.avahi = {
    enable = true;
    #nssmdns = true; #renamed
    nssmdns4 = true;
    publish = {
      enable = true;
      addresses = true;
      domain = true;
      hinfo = true;
      userServices = true;
      workstation = true;
    };
    extraServiceFiles = {
      smb = ''
        <?xml version="1.0" standalone='no'?><!--*-nxml-*-->
        <!DOCTYPE service-group SYSTEM "avahi-service.dtd">
        <service-group>
          <name replace-wildcards="yes">%h</name>
          <service>
            <type>_smb._tcp</type>
            <port>445</port>
          </service>
        </service-group>
      '';
    };
  };
}

