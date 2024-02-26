{
  description = "Jacobs NixOS System Flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";

    hyprland = {
      url = "github:hyprwm/Hyprland";
      inputs.nixpkgs.follows = "nixpkgs"; # MESA/OpenGL HW workaround
    };
  };

  outputs = {
    self,
    nixpkgs,
    hyprland,
    ...
  } @ inputs: {
    nixosConfigurations.desktop = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = {inherit hyprland;};
      modules = [
        ./hosts/desktop/configuration.nix

        hyprland.nixosModules.default
        {
          programs.hyprland = {
            enable = true;
            xwayland = {
              enable = true;
              hidpi = false;
            };
          };
        }
      ];
    };
  };
}
