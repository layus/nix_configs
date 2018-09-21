{pkgs, ...}:
{
  imports = [ ./minimal.nix ];

  boot.kernelPackages = pkgs.linuxPackages_mptcp;

  #environment.systemPackages = [ pkgs.jshon ];
  programs.bash.interactiveShellInit = with pkgs; ''
    amiusingmptcp() { ${curl.bin}/bin/curl 'http://amiusingmptcp.de:5900/v1/check_connection' -qs | ${jshon}/bin/jshon -e mptcp; }
  '';

  virtualisation.qemu.networkingOptions = [
    "-net nic,vlan=0,model=e1000" # Replace virtio, otherwise mptcp is bypassed
    "-net user,vlan=0\${QEMU_NET_OPTS:+,$QEMU_NET_OPTS}"
  ];
}
