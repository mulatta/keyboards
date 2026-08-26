{
  buildQmkFirmware,
  fetchFromGitHub,
  lib,
}:

let
  chibios = fetchFromGitHub {
    owner = "qmk";
    repo = "ChibiOS";
    rev = "be44b3305f9a9fe5f2f49a4e7b978db322dc463e";
    hash = "sha256-e0K+zXbTbfh/kP7JbTS624gGhtrKSg56yOfkq2salA8=";
  };
  chibiosContrib = fetchFromGitHub {
    owner = "qmk";
    repo = "ChibiOS-Contrib";
    rev = "77cb0a4f7589f89e724f5e6ecb1d76d514dd1212";
    hash = "sha256-DHizIK4XWe3wnYC/MaeoQu+idL2lXApu7BxzcbchdYY=";
  };
  lufa = fetchFromGitHub {
    owner = "qmk";
    repo = "lufa";
    rev = "549b97320d515bfca2f95c145a67bd13be968faa";
    hash = "sha256-BCaLSOn9ksj0+gYNdiTkZqrgKbGEbWNxnxrh3TOpsOY=";
  };
  printf = fetchFromGitHub {
    owner = "qmk";
    repo = "printf";
    rev = "c2e3b4e10d281e7f0f694d3ecbd9f320977288cc";
    hash = "sha256-RgeQ1Hg1j9DF4C2N/0Qh6iGAFg8vAY1NdbxFMCcMoGQ=";
  };
  qmkSource = fetchFromGitHub {
    owner = "zsa";
    repo = "qmk_firmware";
    rev = "c9fe0e2960cd96db31c627ab7215d93436305fed";
    hash = "sha256-0OJTloNAfUu6oCHw+UltVFtV7ohS1JtYWALqEi/P9/I=";
  };
  zsaModules = fetchFromGitHub {
    owner = "zsa";
    repo = "qmk_modules";
    rev = "13890cd7856175de20798689d15ba6a46bf0c5c7";
    hash = "sha256-QrwXzNAtX7UakXz0jzL5R3vU1zbg6Juk9aO5daZN7+I=";
  };
in
buildQmkFirmware {
  pname = "zsa-voyager-firmware";
  version = "0-unstable";

  qmkFirmware = qmkSource;
  keyboard = "zsa/voyager";
  keymap = "dots";
  keymapSource = ../voyager;
  firmwareFile = "zsa_voyager_dots.bin";

  sourceMounts = {
    "lib/chibios" = chibios;
    "lib/chibios-contrib" = chibiosContrib;
    "lib/lufa" = lufa;
    "lib/printf" = printf;
    "modules/zsa" = zsaModules;
  };

  meta = {
    description = "QMK firmware for ZSA Voyager";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.unix;
  };
}
