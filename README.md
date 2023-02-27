# Nix package and service for fw-fanctrl
A Nix package and systemd service for [fw-fanctrl](https://github.com/TamtamHero/fw-fanctrl). Some small changes were required to correctly package it, so I am using [a fork of the original repo](https://github.com/mdvmeijer/fw-fanctrl). Someone more experienced with Nix may know a way to do this without the changes, so please feel free to contribute.

## How to clone
`git clone --recurse-submodules git@github.com:mdvmeijer/fw-fanctrl-nix.git`


## How to use on NixOS
1. add `/path/to/fw-fanctrl-nix/service.nix` to your `configuration.nix` or to any module imported by it, e.g. like
```
  imports =
     [
       /home/user1/fw-fanctrl-nix/service.nix
     ];
```

2. Enable the service with `services.fw-fanctrl.enable = true;`.


## How to configure
By default, the service follows the configuration defined in `config.json`. If you want to change the configuration, either edit `config.json` or create your own config file and add `services.fw-fanctrl.configJsonPath = /path/to/your/fw-fanctrl-config.json;` to your `configuration.nix`.

For more information about the configuration format and semantics, refer to [fw-fanctrl](https://github.com/TamtamHero/fw-fanctrl)'s README.
