{ config, pkgs, ... }:

{
  programs.starship = {
    enable = true;
    enableBashIntegration = true;

    # settings = {
    #   format = "$directory$git_branch$git_status$python$nodejs$rust\n[\\[$username@$hostname\\]](bold green)$character";

    #   directory = {
    #     read_only = " ro";
    #     style = "bold green";
    #   };

    #   username = {
    #     show_always = true;
    #     format = "$user";
    #   };

    #   hostname = {
    #     ssh_only = false;
    #     format = "$hostname";
    #   };

    #   character = {
    #     success_symbol = "[\\$](bold green)";
    #     error_symbol = "[\\$](bold green)";
    #   };
    # };
  };
}
