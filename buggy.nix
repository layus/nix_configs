{...}:
{
  systemd.mounts = [
    {
      where = "/mnt";
      what = "/";
      
      requiredBy = ["lol.target"];
    }
  ];
}
