{
  description = "lapstrop's nixos configuration";

  #========  INPUTS
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";

    #========  HOME MANAGER
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    #========  FLATPAK
    nix-flatpak = {
      url = "github:gmodena/nix-flatpak/?ref=latest";
    };

    #========  AREOFYL-FETCH
    areofyl-fetch = {
      url = "github:areofyl/fetch";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  #========  OUTPUTS
  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      nix-flatpak,
      areofyl-fetch,
      ...
    }:
    {
      nixosConfigurations.lapstrop = nixpkgs.lib.nixosSystem {
        modules = [
          ./configuration.nix
          { nixpkgs.hostPlatform = "x86_64-linux"; }
          { nix.registry.nixpkgs.flake = nixpkgs; }

          #========  HOME MANAGER MODULE
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users.lapstrop = import ./home_manager.nix;
              backupFileExtension = "hm-bak";
            };
          }

          #========  FLATPAK MODULE
          nix-flatpak.nixosModule.nix-flatpak

          #========  AREOFYL-FETCH MODULE
          ({ pkgs, ... }: {
            nixpkgs.overlays = [
              areofyl-fetch.overlays.default
            ];
            environment.systemPackages = [
              areofyl-fetch.packages.${pkgs.stdenv.hostPlatform.system}.default
            ];
          })
        ];
      };
    };
}
