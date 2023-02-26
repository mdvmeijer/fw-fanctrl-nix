# based on https://blog.stigok.com/2019/11/05/packing-python-script-binary-nicely-in-nixos.html
{ nixpkgs ? import <nixpkgs> {}, pythonPkgs ? nixpkgs.pkgs.python310Packages, lib ? import <lib> {} }:

let
  inherit (nixpkgs) pkgs;
  inherit pythonPkgs;

  f = { buildPythonPackage, watchdog, bash, lm_sensors, ectool, lib }:
    buildPythonPackage rec {
      pname = "fw-fanctrl";
      version = "0.0.1";

      src = builtins.fetchGit {
        url = "https://github.com/mdvmeijer/fw-fanctrl";
        ref = "main";
      };

      # Python runtime dependencies
      propagatedBuildInputs = [ watchdog ];

      # Runtime dependencies that the script calls with `subprocess.run`
      makeWrapperArgs = [ "--prefix PATH : ${lib.makeBinPath [ 
        bash
        lm_sensors
        (import (./. + "/fw-ectool/default.nix"))
        ]}" ];

      meta = {
        description = ''
          Python script for better control of the Framework Laptop's fan
        '';
      };
    };

  drv = pythonPkgs.callPackage f {};
in
  if pkgs.lib.inNixShell then drv.env else drv
