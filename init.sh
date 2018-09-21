#! @shell@

systemConfig=@systemConfig@

export HOME=/root


# Print a greeting.
echo
echo -e "\e[1;32m<<< NixOS Stage 2 for Docker >>>\e[0m"
echo


# Set the PATH.
setPath() {
    local dirs="$1"
    export PATH=/empty
    for i in $dirs; do
        PATH=$PATH:$i/bin
        if test -e $i/sbin; then
            PATH=$PATH:$i/sbin
        fi
    done
}

setPath "@path@"
date +"# %S.%N"

# Provide a /etc/mtab.
mkdir -m 0755 -p /etc
test -e /etc/fstab || touch /etc/fstab # to shut up mount
rm -f /etc/mtab* # not that we care about stale locks
ln -s /proc/mounts /etc/mtab


# More special file systems, initialise required directories.
mkdir -m 0755 -p /dev/shm
mkdir -m 0755 -p /dev/pts
mkdir -m 01777 -p /tmp
mkdir -m 0755 -p /var /var/log /var/lib /var/db
mkdir -m 0755 -p /nix/var
mkdir -m 0700 -p /root
chmod 0700 /root
mkdir -m 0755 -p /bin # for the /bin/sh symlink
mkdir -m 0755 -p /home
mkdir -m 0755 -p /etc/nixos


# Miscellaneous boot time cleanup.
rm -rf /var/run /var/lock
rm -f /etc/{group,passwd,shadow}.lock


mkdir -m 0755 -p /run
mkdir -m 0755 -p /run/lock


# For backwards compatibility, symlink /var/run to /run, and /var/lock
# to /run/lock.
ln -s /run /var/run
ln -s /run/lock /var/lock

# Create /var/setuid-wrappers as a tmpfs.
mkdir -m 0755 -p /var/setuid-wrappers

echo -n before activate ; date +"# %S.%N"
# Run the script that performs all configuration activation that does
# not have to be done at boot time.
echo "running activation script..."
$systemConfig/activate

echo -n before postboot; date +"# %S.%N"
# Run any user-specified commands.
@shell@ @postBootCommands@

date +"# %S.%N"
@shell@ -l "$@"
date +"# %S.%N"
