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
  boot.loader.systemd-boot.configurationLimit = 10;
  boot.loader.efi.canTouchEfiVariables = true;
  # boot.loader.timeout = 2;

  nix.settings = {
    experimental-features = ["nix-command" "flakes"];
    trusted-users = [
      "sineptic"
    ];
  };
  time.timeZone = "Europe/Moscow";

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
    extraGroups = ["wheel" "docker"];
    packages = with pkgs; [
      eza
      ungoogled-chromium
      yazi
      halloy

      lua-language-server
      typos
      clang-tools

      rustup
      zig
      just
      cargo-nextest
      cargo-flamegraph
      bun
      deno
      uv
      uxn
      go
      gopls
      gofumpt

      telegram-desktop
      zellij
      starship
      gnomeExtensions.blur-my-shell
      gnome-tweaks
      obsidian
      cassette
      foliate

      delta
      difftastic

      rose-pine-cursor

      cargo-binstall
      tokei
      single-file-cli

      # Experimental apps, maybe unneeded
      blanket
      bustle
      curtail
      dialect
      errands
      junction
      newsflash
      gnome-obfuscate
      resources
      tuba
    ];
  };

  fonts.packages = with pkgs;
    [
      recursive
      inter
      maple-mono.CN
      dm-mono

      atkinson-hyperlegible-next
      lexend
      work-sans
    ]
    ++ (with pkgs.nerd-fonts; [
      space-mono
      martian-mono
      jetbrains-mono
      zed-mono
      geist-mono
      terminess-ttf
      gohufont
      fantasque-sans-mono
    ]);
  fonts.enableDefaultPackages = false;

  environment.systemPackages =
    (with pkgs; [
      jujutsu
      lazygit
      clang
      nushell

      alacritty
      fish
      wget
      btop
      xclip
      ripgrep
      byedpi
      sd
      file

      zed-editor
      nixd
      nil
      alejandra

      kubo
      # docker
      tor-browser-bundle-bin
      protonvpn-gui

      gprof2dot
      linuxKernel.packages.linux_6_6.perf
      graphviz
    ])
    ++ (with pkgs-stable; [
      git
      vim
      neovim

      gnupg
      pass

      yandex-music # new version doesn't work somewhy
    ]);
  # virtualisation.docker.enable = true;

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

    source-code-pro
    cantarell-fonts
    dejavu_fonts
    source-sans
  ];
  services = {
    flatpak.enable = true;

    xserver = {
      enable = true;
      xkb = {
        layout = "us,ru";
        options = "grp:win_space_toggle";
        # options = "eurosign:e,caps:escape";
      };
    };
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;

    # tor.enable = true;
    # tor.client.enable = true;
  };
  systemd.user.services.gnome-session-restart-dbus.serviceConfig = {
    Slice = "-.slice";
  };

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
