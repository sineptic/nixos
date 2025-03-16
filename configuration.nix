# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).
{
  config,
  lib,
  pkgs,
  pkgs-stable,
  ...
}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];
  hardware.graphics.enable = true;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  # boot.loader.timeout = 2;

  nix.settings.experimental-features = ["nix-command" "flakes"];
  time.timeZone = "Europe/Moscow";

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us,ru";
    options = "grp:win_space_toggle";
  };
  # services.xserver.xkb.options = "eurosign:e,caps:escape";

  # Enable sound.
  # hardware.pulseaudio.enable = true;
  # OR
  # services.pipewire = {
  #   enable = true;
  #   pulse.enable = true;
  # };

  nixpkgs.config.allowUnfree = true;

  services.pcscd.enable = true;
  programs.gnupg.agent = {
    enable = true;
    pinentryPackage = pkgs.pinentry-gnome3;
    enableSSHSupport = true;
  };

  users.users.sineptic = {
    isNormalUser = true;
    extraGroups = ["wheel"];
    packages = with pkgs; [
      eza
      ungoogled-chromium
      yazi
      lazygit

      lua-language-server
      typos
      clang-tools

      rustup
      zig
      just
      cargo-nextest
      deno
      uv

      telegram-desktop
      zellij
      starship
      gnomeExtensions.blur-my-shell
      gnome-tweaks
      obsidian

      delta

      rose-pine-cursor

      cargo-binstall
      tokei

      go
      gopls
      gofumpt

      cargo-flamegraph
    ];
  };

  fonts.packages = with pkgs; [
    nerd-fonts.space-mono
    nerd-fonts.martian-mono
    nerd-fonts.jetbrains-mono
    nerd-fonts.zed-mono
    nerd-fonts.geist-mono
    inter
  ];
  fonts.enableDefaultPackages = false;

  environment.systemPackages =
    (with pkgs; [
      jujutsu
      clang

      alacritty
      fish
      wget
      btop
      xclip
      ripgrep
      byedpi
      sd

      zed-editor
      nixd
      nil
      alejandra
    ])
    ++ (with pkgs-stable; [
      git
      vim
      neovim

      gnupg
      pass
    ]);

  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    # Add any missing dynamic libraries for unpackaged programs
    # here, NOT in environment.systemPackages
    typos-lsp
  ];
  environment.variables = {
    EDITOR = "nvim";
    # SHELL = "fish";
    ZED_ALLOW_EMULATED_GPU = "1";
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  services.flatpak.enable = true;

  services.xserver = {
    enable = true;
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
  };
  environment.gnome.excludePackages = with pkgs; [
    orca
    geary
    gnome-tour
    epiphany
    gnome-text-editor
    gnome-characters
    gnome-console
    gnome-maps
    gnome-music
    gnome-weather
    snapshot
    simple-scan
  ];

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "24.05"; # Did you read the comment?
}
