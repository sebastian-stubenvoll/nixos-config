{ config, pkgs, ... }:

{
 programs.git = {
  enable = true;
  settings = {
    user = {
     name = "Sebastian";
     email = "49613760+sebastian-stubenvoll@users.noreply.github.com";
    };
    init.defaultBranch = "main";
   };
 };
}
