{ inputs, ... }:
let
  unstable = inputs.nixpkgs-unstable.legacyPackages.x86_64-linux;
in
{
  nixpkgs.overlays = [
    (final: prev: {
      amnezia-vpn = unstable.amnezia-vpn;
    })
  ];
}
