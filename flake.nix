# https://drakerossman.com/blog/how-to-convert-default-nixos-to-nixos-with-flakes
# https://nixos-and-flakes.thiscute.world/nixos-with-flakes/downgrade-or-upgrade-packages
# https://discourse.nixos.org/t/flakes-vs-channels-guides-and-clarification/29804
#

{
  description = "flake for sapientia";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";

    # Latest stable branch of nixpkgs, used for version rollback.
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    #agenix.url = "github:ryantm/agenix";
    # optional, not necessary for the module
    #agenix.inputs.nixpkgs.follows = "nixpkgs";
    # optionally choose not to download darwin deps (saves some resources on Linux)
    #agenix.inputs.darwin.follows = "";
  };

  outputs = { self,
              nixpkgs,
              nixpkgs-unstable,
              #agenix
            }: {
    nixosConfigurations = {
      sapientia = nixpkgs.lib.nixosSystem rec {
        system = "x86_64-linux";

        # The `specialArgs` parameter passes the non-default nixpkgs instances to other nix modules.
        specialArgs = {
          # To use packages from nixpkgs-stable we configure some parameters for it first.
          pkgs-unstable = import nixpkgs-unstable {
            # Refer to the `system` parameter from the outer scope recursively.
            inherit system;
            #config.allowUnfree = true;
          };
        };
        modules = [
          #{
          #  environment.systemPackages = [ agenix.packages.${system}.default ];
          #}
          ./configuration.nix
          #agenix.nixosModules.default
        ];
      };
    };
  };
}
