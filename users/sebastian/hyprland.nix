{ config, pkgs, ... }:

# Bare fallback session. Bar, wallpaper, lock/idle, monitors, notifications
# and polkit come from the shared services in desktop.nix and friends.

let
  screenshotDir = "${config.home.homeDirectory}/Screenshots";
in
{
  wayland.windowManager.hyprland = {
    enable = true;
    systemd.enable = false;
    configType = "lua";

    # Plain options: each attribute becomes an hl.<name>(...) call.
    settings = {
      env = [
        { _args = [ "XCURSOR_THEME" "Adwaita" ]; }
        { _args = [ "XCURSOR_SIZE" "20" ]; }
      ];

      config = {
        input = {
          kb_layout = "de";
          kb_variant = "mac";
          kb_options = "caps:escape,lv3:lalt_switch,compose:menu";
          repeat_delay = 250;
          follow_mouse = 1;
          touchpad = {
            tap_to_click = false;
            natural_scroll = true;
            clickfinger_behavior = true;
          };
        };

        general = {
          gaps_in = 0;
          gaps_out = 0;
        };

        misc = {
          force_default_wallpaper = 0;
          disable_hyprland_logo = true;
          focus_on_activate = true;
        };
      };

      window_rule = [
        {
          match.content = 3;
          fullscreen = true;
        }
        {
          # Some apps (kitty) ask to open maximized; tile them normally instead
          match.class = ".*";
          suppress_event = "maximize";
        }
      ];
    };

    # Binds, submaps and autostart are easier to read as plain Lua.
    extraConfig = ''
      hl.on("hyprland.start", function()
        hl.exec_cmd("hyprctl setcursor Adwaita 20")
      end)

      local dirs = { h = "left", j = "down", k = "up", l = "right" }

      for key, dir in pairs(dirs) do
        -- Move focus
        hl.bind("SUPER + " .. key, hl.dsp.focus({ direction = dir }))
        -- Move windows
        hl.bind("SUPER + SHIFT + " .. key, hl.dsp.window.move({ direction = dir }))
      end

      -- Change workspace (F-keys and number row)
      for i = 1, 9 do
        for _, key in ipairs({ "f" .. i, tostring(i) }) do
          hl.bind("SUPER + " .. key, hl.dsp.focus({ workspace = i }))
          hl.bind("SUPER + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
        end
      end

      -- Move active window to a monitor in the specified direction
      hl.bind("SUPER + I", hl.dsp.window.move({ direction = "left" }))
      hl.bind("SUPER + O", hl.dsp.window.move({ direction = "right" }))

      -- Move the current workspace to a monitor in the specified direction
      hl.bind("SUPER + SHIFT + I", hl.dsp.workspace.move({ monitor = "l" }))
      hl.bind("SUPER + SHIFT + O", hl.dsp.workspace.move({ monitor = "r" }))

      -- Resizing
      hl.bind("SUPER + R", hl.dsp.submap("resize"))
      hl.define_submap("resize", function()
        hl.bind("escape", hl.dsp.submap("reset"))
        hl.bind("h", hl.dsp.window.resize({ x = -10, y = 0, relative = true }), { repeating = true })
        hl.bind("j", hl.dsp.window.resize({ x = 0, y = 10, relative = true }), { repeating = true })
        hl.bind("k", hl.dsp.window.resize({ x = 0, y = -10, relative = true }), { repeating = true })
        hl.bind("l", hl.dsp.window.resize({ x = 10, y = 0, relative = true }), { repeating = true })
      end)

      -- Disable all binds until pressed again
      hl.bind("SUPER + SHIFT + D", hl.dsp.submap("disable"))
      hl.define_submap("disable", function()
        hl.bind("SUPER + SHIFT + D", hl.dsp.submap("reset"))
      end)

      -- Lock (swayidle runs swaylock on the lock event)
      hl.bind("SUPER + SHIFT + CONTROL + D", hl.dsp.exec_cmd("loginctl lock-session"))

      -- Floating toggle; SHIFT floats and pins
      hl.bind("SUPER + F", hl.dsp.window.float({ action = "toggle" }))
      hl.bind("SUPER + SHIFT + F", function()
        hl.dispatch(hl.dsp.window.float({ action = "set" }))
        hl.dispatch(hl.dsp.window.pin({ action = "toggle" }))
      end)

      -- Fullscreen
      hl.bind("SUPER + SHIFT + M", hl.dsp.window.fullscreen({ mode = "fullscreen", action = "toggle" }))

      -- Launch things
      hl.bind("SUPER + T", hl.dsp.exec_cmd("kitty"))
      hl.bind("CONTROL + space", hl.dsp.exec_cmd("tofi-drun --drun-launch=true"))
      hl.bind("SUPER + SHIFT + E", hl.dsp.exec_cmd("powermenu"))
      hl.bind("SUPER + X", hl.dsp.window.close())
      hl.bind("SUPER + SHIFT + X", hl.dsp.window.kill())

      -- Screenshot
      local shotFile = "${screenshotDir}/Screenshot-$(date +%F_%H-%M-%S).png"
      hl.bind("SUPER + S", hl.dsp.exec_cmd('grim -g "$(slurp)" - | wl-copy'))
      hl.bind("SUPER + SHIFT + S", hl.dsp.exec_cmd('grim -g "$(slurp)" ' .. shotFile))
      hl.bind("SUPER + CONTROL + SHIFT + S", hl.dsp.exec_cmd("grim " .. shotFile))
      hl.bind("SUPER + CONTROL + S", hl.dsp.exec_cmd("screenshot-annotate"))
    '';
  };
}
