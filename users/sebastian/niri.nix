{ config, pkgs, lib, ... }:

# niri compositor config. Session tools (bar, wallpaper, idle, monitors, ...)
# live in desktop.nix and start through systemd.
#
# The KDL is checked with `niri validate` at build time, so a typo fails the
# rebuild instead of falling back to niri's default config at login.

let
  makoctl = "${pkgs.mako}/bin/makoctl";
  osd = "${pkgs.swayosd}/bin/swayosd-client";
  playerctl = lib.getExe pkgs.playerctl;
  cliphist = lib.getExe pkgs.cliphist;
  wl-copy = "${pkgs.wl-clipboard}/bin/wl-copy";
  jq = lib.getExe pkgs.jq;

  workspaceBinds = lib.concatMapStrings (n: ''
    Mod+${n} { focus-workspace ${n}; }
    Mod+F${n} { focus-workspace ${n}; }
    Mod+Shift+${n} { move-column-to-workspace ${n}; }
    Mod+Shift+F${n} { move-column-to-workspace ${n}; }
  '') (map toString (lib.range 1 9));

  configText = ''
    input {
        keyboard {
            xkb {
                layout "de"
                variant "mac"
                options "caps:escape,lv3:lalt_switch,compose:menu"
            }
            repeat-delay 250
        }
        touchpad {
            natural-scroll
            click-method "clickfinger"
        }
        focus-follows-mouse
    }

    // Outputs are handled by kanshi (desktop.nix). niri itself turns the
    // laptop panel off when the lid closes.

    cursor {
        xcursor-theme "Adwaita"
        xcursor-size 20
    }

    layout {
        gaps 12
        center-focused-column "never"
        preset-column-widths {
            proportion 0.33333
            proportion 0.5
            proportion 0.66667
        }
        default-column-width { proportion 0.5; }
        focus-ring {
            width 2
            active-color "#d0d0d0"
            inactive-color "#505050"
        }
        border { off; }
    }

    prefer-no-csd
    screenshot-path "~/Screenshots/Screenshot %Y-%m-%d %H-%M-%S.png"

    hotkey-overlay {
        skip-at-startup
    }

    // Steam games open fullscreen (was Hyprland's content-type rule)
    window-rule {
        match app-id=r#"^steam_app_"#
        open-fullscreen true
    }

    binds {
        // Focus
        Mod+H { focus-column-or-monitor-left; }
        Mod+L { focus-column-or-monitor-right; }
        Mod+J { focus-window-or-workspace-down; }
        Mod+K { focus-window-or-workspace-up; }

        // Move
        Mod+Shift+H { move-column-left-or-to-monitor-left; }
        Mod+Shift+L { move-column-right-or-to-monitor-right; }
        Mod+Shift+J { move-window-down-or-to-workspace-down; }
        Mod+Shift+K { move-window-up-or-to-workspace-up; }

        // Workspaces (1-9 and F1-F9)
        ${workspaceBinds}

        // Monitors
        Mod+I { move-column-to-monitor-left; }
        Mod+O { move-column-to-monitor-right; }
        Mod+Shift+I { move-workspace-to-monitor-left; }
        Mod+Shift+O { move-workspace-to-monitor-right; }

        // Resize (niri has no submaps)
        Mod+R { switch-preset-column-width; }
        Mod+Ctrl+H { set-column-width "-10%"; }
        Mod+Ctrl+L { set-column-width "+10%"; }
        Mod+Ctrl+J { set-window-height "+10%"; }
        Mod+Ctrl+K { set-window-height "-10%"; }

        // Columns
        Mod+Comma { consume-or-expel-window-left; }
        Mod+Period { consume-or-expel-window-right; }
        Mod+C { center-column; }
        Mod+W { toggle-column-tabbed-display; }
        Mod+Tab repeat=false { toggle-overview; }

        // Pass all keys to apps that ask for it (VMs, remote desktop)
        Mod+Shift+D allow-inhibiting=false { toggle-keyboard-shortcuts-inhibit; }

        // Lock
        Mod+Shift+Ctrl+D allow-inhibiting=false { spawn "loginctl" "lock-session"; }

        // Floating / fullscreen
        Mod+F { toggle-window-floating; }
        Mod+Shift+F { move-window-to-floating; }
        Mod+Shift+M { fullscreen-window; }

        // Apps
        Mod+T { spawn "kitty"; }
        Ctrl+Space { spawn "fuzzel"; }
        Mod+V { spawn-sh "${cliphist} list | fuzzel --dmenu | ${cliphist} decode | ${wl-copy}"; }
        Mod+Shift+E { spawn "powermenu"; }
        Mod+X repeat=false { close-window; }
        Mod+Shift+X repeat=false { spawn-sh "kill -9 $(niri msg --json focused-window | ${jq} .pid)"; }

        // Notifications
        Mod+N { spawn "${makoctl}" "dismiss"; }
        Mod+Shift+N { spawn "${makoctl}" "mode" "-t" "do-not-disturb"; }

        // Screenshots. In the region UI: Ctrl+C = clipboard only,
        // Enter/Space = save to ~/Screenshots + clipboard.
        Mod+S { screenshot; }
        Mod+Shift+S { screenshot-window; }
        Mod+Ctrl+Shift+S { screenshot-screen; }
        Mod+Ctrl+S { spawn "screenshot-annotate"; }

        // Help (Super+? on the German layout)
        Mod+Shift+ssharp { show-hotkey-overlay; }

        // Media keys
        XF86AudioRaiseVolume allow-when-locked=true { spawn "${osd}" "--output-volume" "raise"; }
        XF86AudioLowerVolume allow-when-locked=true { spawn "${osd}" "--output-volume" "lower"; }
        XF86AudioMute allow-when-locked=true { spawn "${osd}" "--output-volume" "mute-toggle"; }
        XF86AudioMicMute allow-when-locked=true { spawn "${osd}" "--input-volume" "mute-toggle"; }
        XF86MonBrightnessUp allow-when-locked=true { spawn "${osd}" "--brightness" "raise"; }
        XF86MonBrightnessDown allow-when-locked=true { spawn "${osd}" "--brightness" "lower"; }
        XF86AudioPlay allow-when-locked=true { spawn "${playerctl}" "play-pause"; }
        XF86AudioPause allow-when-locked=true { spawn "${playerctl}" "play-pause"; }
        XF86AudioNext allow-when-locked=true { spawn "${playerctl}" "next"; }
        XF86AudioPrev allow-when-locked=true { spawn "${playerctl}" "previous"; }
    }
  '';

  validatedConfig = pkgs.runCommand "niri-config.kdl"
    {
      nativeBuildInputs = [ pkgs.niri ];
      passAsFile = [ "configText" ];
      inherit configText;
    }
    ''
      niri validate -c "$configTextPath"
      cp "$configTextPath" "$out"
    '';
in
{
  xdg.configFile."niri/config.kdl".source = validatedConfig;
}
