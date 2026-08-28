{
  den,
  inputs,
  self,
  ...
}:
{
  imports = [
    inputs.den.flakeModule
    (inputs.den.namespace "heitor" true)
  ];

  heitor.emacs = package': {
    includes = [
      ({ host, ... }: { ${host.class}.nixpkgs.overlays = [ self.overlays.default ]; })
      ({ home }: { ${home.class}.nixpkgs.overlays = [ self.overlays.default ]; })
    ];

    homeManager =
      { pkgs, ... }:
      let
        package = package' pkgs;
      in
      {
        home.packages = [ package ];

        services.emacs = {
          enable = true;
          inherit package;
          client.enable = true;
          defaultEditor = true;
          socketActivation.enable = true;
        };
      };
  };
}
