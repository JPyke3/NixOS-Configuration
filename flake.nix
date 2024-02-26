{
  description = "Jacobs NixOS System Flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
    nixpkgs.overlays = [
    (final: prev:
      {
        hyprland = inputs.hyprland.packages.${pkgs.system}.hyprland;
        wlroots-hyprland = inputs.hyprland.packages.${pkgs.system}.wlroots-hyprland;
        wlroots = inputs.nixpkgs_unstable.legacyPackages.${pkgs.system}.wlroots;
      })
    (final: prev: {
      wlroots = prev.wlroots.override {
        xwayland = prev.xwayland;
        mesa = pkgs.mesa;
      };
    })
    (final: prev: {
      wlroots = prev.wlroots.overrideAttrs (old: {
        nativeBuildInputs = old.nativeBuildInputs ++
          [ inputs.nixpkgs_unstable.legacyPackages.${pkgs.system}.libdrm ];
      });
    })
    (final: prev: {
      wlroots-hyprland = prev.wlroots-hyprland.override { wlroots = prev.wlroots; };
    })
    (final: prev: {
      hyprland = prev.hyprland.override {
        mesa = pkgs.mesa;
        wlroots = prev.wlroots-hyprland;
      };
    })
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
      ];
    };
  };
}
