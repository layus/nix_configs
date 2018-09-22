#!/usr/bin/env bash
set -ex

NIXOS_CONFIG=$PWD/docker-test.nix nixos-rebuild build
date +"%T.%N"; time docker run -i -v /nix/store:/nix/store/:ro tianon/true $(readlink ./result)/init -c "echo lol"; date +"%T.%N"

