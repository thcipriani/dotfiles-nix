{ config, lib, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "thcipriani";
  home.homeDirectory = "/home/thcipriani";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.05"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = [
    pkgs.waybar
    pkgs.wofi
    pkgs.grim
    pkgs.slurp
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/thcipriani/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    # EDITOR = "emacs";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  wayland.windowManager.sway = {
    enable = true;
    config = {
      modifier = "Mod4";
      input."type:keyboard" = {
        xkb_layout = "us";
        xkb_variant = "altgr-intl";
        xkb_options = "ctrl:nocaps,compose:rctrl";
        repeat_delay = "330";
        repeat_rate = "60";
      };
      input."type:touchpad" = {
        tap = "enabled";
        dwt = "enabled";
        natural_scroll = "enabled";
        middle_emulation = "enabled";
      };
      bars = [{
        # position = "bottom";
        # height = 30;
        statusCommand = "${pkgs.waybar}/bin/waybar";
      }];
      keybindings = let
        mod = config.wayland.windowManager.sway.config.modifier;
        up = config.wayland.windowManager.sway.config.up;
        down = config.wayland.windowManager.sway.config.down;
        menu = config.wayland.windowManager.sway.config.menu;
        term = config.wayland.windowManager.sway.config.terminal;
      in
      lib.mkOptionDefault {
        "${mod}+space" = "layout toggle all";
        "${mod}+${down}" = "focus next";
        "${mod}+${up}" = "focus prev";
        "${mod}+Shift+Return" = "exec ${term}";
        "${mod}+Shift+s" = "exec ${pkgs.grim}/bin/grim ~/Pictures/screenshots/$(date +%Y-%m-%d-%H-%M-%S).png";
        "${mod}+Shift+x" = "exec ${pkgs.grim}/bin/grim -g \"$(slurp)\" ~/Pictures/screenshots/$(date +%Y-%m-%d-%H-%M-%S).png";
        "${mod}+Shift+c" = "kill";
        "${mod}+p" = "exec ${menu}";
        "${mod}+q" = "reload";
        "${mod}+1" = "[workspace=\"^1$\"] move workspace to output current; workspace number 1";
        "${mod}+2" = "[workspace=\"^2$\"] move workspace to output current; workspace number 2";
        "${mod}+3" = "[workspace=\"^3$\"] move workspace to output current; workspace number 3";
        "${mod}+4" = "[workspace=\"^4$\"] move workspace to output current; workspace number 4";
        "${mod}+5" = "[workspace=\"^5$\"] move workspace to output current; workspace number 5";
        "${mod}+6" = "[workspace=\"^6$\"] move workspace to output current; workspace number 6";
        "${mod}+7" = "[workspace=\"^7$\"] move workspace to output current; workspace number 7";
        "${mod}+8" = "[workspace=\"^8$\"] move workspace to output current; workspace number 8";
        "${mod}+9" = "[workspace=\"^9$\"] move workspace to output current; workspace number 9";
        "${mod}+0" = "[workspace=\"^10$\"] move workspace to output current; workspace number 10";
        "${mod}+l" = "exec '~/.config/swaylock/lock.sh'";
        "${mod}+shift+p" = "exec sh -c 'swaymsg [app_id=\"dropdown_term\"] scratchpad show || exec ${term} --app-id dropdown_term'";
        "XF86AudioRaiseVolume" = "exec pactl set-sink-volume @DEFAULT_SINK@ +5%";
        "XF86AudioLowerVolume" = "exec pactl set-sink-volume @DEFAULT_SINK@ -5%";
        "XF86AudioMute" = "exec pactl set-sink-mute @DEFAULT_SINK@ toggle";
        "XF86AudioMicMute" = "exec pactl set-source-mute @DEFAULT_SOURCE@ toggle";
        "XF86MonBrightnessDown" = "exec brightnessctl set 5%-";
        "XF86MonBrightnessUp" = "exec brightnessctl set 5%+";
        "XF86AudioPlay" = "exec playerctl play-pause";
        "XF86AudioNext" = "exec playerctl next";
        "XF86AudioPrev" = "exec playerctl previous";
      };
      output = {
        "DP-2" = {
          position = "0,0";
        };
        "eDP-1" = {
          position = "1920,0";
        };
        "*" = {
          background = "${pkgs.sway}/share/backgrounds/sway/Sway_Wallpaper_Blue_1920x1080.png fill";
        };
      };
      window.hideEdgeBorders = "both";
      window.titlebar = false;
      window.border = 0;
    };
    extraConfig = ''
      exec swayidle -w \
          timeout 900 '~/.config/swaylock/lock.sh' \
          timeout 1200 'swaymsg "output * dpms off"' \
      resume 'swaymsg "output * dpms on"' \
      before-sleep '~/.config/swaylock/lock.sh'

      exec wlsunset -l 40.1 -L -105.1
      include /etc/sway/config.d/*
      for_window [app_id="dropdown_term"] floating enable
      for_window [app_id="dropdown_term"] border pixel 0
      for_window [app_id="dropdown_term"] move scratchpad
      for_window [app_id="dropdown_term"] scratchpad show
      for_window [app_id="dropdown_term"] resize set 500 350
      for_window [app_id="dropdown_term"] move position center
    '';
  };
}
