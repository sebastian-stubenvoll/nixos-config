let
  calculator = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMg41Kb/v+zlceTRrQ4KIrEjBhscfKX6hPyVHuoMfo+5 root@calculator";
in
{
  "uhh-vpn.age".publicKeys = [ calculator ];
}

