# based on https://blog.stigok.com/2019/11/05/packing-python-script-binary-nicely-in-nixos.html
{ config, lib, pkgs, ... }:

let
    fw-fanctrl = pkgs.callPackage ./default.nix {};

    cfg = config.services.fw-fanctrl;
in {
    options.services.fw-fanctrl.enable = lib.mkEnableOption "fw-fanctrl";

    options.services.fw-fanctrl.configJsonPath = lib.mkOption {
        type = lib.types.path;
        default = (./. + "/config.json");
        example = "/home/user/.config/fw-fanctrl-config.json";
    };

    config = lib.mkIf cfg.enable {

        systemd.services.fw-fanctrl = {
            description = "Framework fan controller.";
            environment = {
                PYTHONUNBUFFERED = "1";
            };

            after = [ "multi-user.target" ];
            wantedBy = [ "multi-user.target" ];

            serviceConfig = {
                ExecStart = "${fw-fanctrl}/bin/fanctrl.py --config ${cfg.configJsonPath}";
                Type = "simple";
            };
        };
    };
}
