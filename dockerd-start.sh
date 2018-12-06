#!/bin/sh

export container=docker

echo "Mounting cgroups..."
cgroup_path=/sys/fs/cgroup
base_mount_options=nosuid,nodev,noexec

if ! mountpoint -q "$cgroup_path"; then
    [ -d "$cgroup_path" ] || mkdir -p "$cgroup_path"
    mount -t tmpfs -o "$base_mount_options,uid=0,gid=0,mode=0755" cgroup "$cgroup_path"
fi

cat /proc/self/cgroup | cut -d: -f2 | while read group; do
    mount_options=$base_mount_options,$group
    if echo $group | grep -q '='; then
        group=$(echo $group | cut -d= -f2)
    fi

    if ! mountpoint -q "$cgroup_path/$group"; then
        [ -d "$cgroup_path/$group" ] || mkdir -p "$cgroup_path/$group"
        mount -t cgroup -o $mount_options cgroup "$cgroup_path/$group"
    fi

    if echo $group | grep -q ','; then
        echo $group | tr , '\n' | while read subgroup; do
            [ -L "$cgroup_path/$subgroup" ] || ln -s "$cgroup_path/$group" "$cgroup_path/$subgroup"
        done
    fi
done

echo "Mounting securityfs..."
securityfs_path=/sys/kernel/security

if ! mountpoint -q "$securityfs_path"; then
    [ -d "$securityfs_path" ] || mkdir -p "$securityfs_path"
    mount -t securityfs none "$securityfs_path"
fi

echo -n "Starting dockerd"
if [ "$DOCKERD_BACKGROUND" = "1" ]; then
    echo " in backgroud (log: /var/log/dockerd.log)..."
    nohup dockerd --host=unix:///var/run/docker.sock --host=tcp://0.0.0.0:2375 "$@" &>/var/log/dockerd.log &
    until docker info &>/dev/null; do sleep 1; done
else
    echo "..."
    exec dockerd --host=unix:///var/run/docker.sock --host=tcp://0.0.0.0:2375 "$@"
fi
