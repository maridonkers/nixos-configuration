# https://drakerossman.com/blog/how-to-convert-default-nixos-to-nixos-with-flakes
# https://nixos-and-flakes.thiscute.world/nixos-with-flakes/downgrade-or-upgrade-packages
# https://nixos.wiki/wiki/Comparison_of_secret_managing_schemes
# https://github.com/chvp/nixos-config
# https://github.com/ryantm/agenix
#

{
  description = "flake for sapientia";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    # Latest stable branch of nixpkgs, used for version rollback.
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-23.11";

    agenix.url = "github:ryantm/agenix";
    # optional, not necessary for the module
    #agenix.inputs.nixpkgs.follows = "nixpkgs";
    # optionally choose not to download darwin deps (saves some resources on Linux)
    #agenix.inputs.darwin.follows = "";
  };

  outputs = { self,
              nixpkgs,
              nixpkgs-stable,
              agenix
            }: {
    nixosConfigurations = {
      sapientia = nixpkgs.lib.nixosSystem rec {
        system = "x86_64-linux";

        # The `specialArgs` parameter passes the non-default nixpkgs instances to other nix modules.
        specialArgs = {
          # To use packages from nixpkgs-stable we configure some parameters for it first.
          pkgs-stable = import nixpkgs-stable {
            # Refer to the `system` parameter from the outer scope recursively.
            inherit system;
            #config.allowUnfree = true;
          };
        };
        modules = [
          {
            environment.systemPackages = [ agenix.packages.${system}.default ];
          }
          ./configuration.nix
          agenix.nixosModules.default
        ];
      };
    };
  };
}
