#!/usr/bin/env python3

import os
import sys

from itertools import tee
def pairwise(iterable):
    "s -> (s0,s1), (s1,s2), (s2, s3), ..."
    a, b = tee(iterable)
    next(b, None)
    return zip(a, b)

times = []
times = sys.stdin.read().split()

times = list(map(float, times))

diffs = [0.0] + [y-x for x, y in pairwise(times)]

labels = [ "", "Docker startup", "NixOS Startup", "Bash + sleep 1", "Docker exit" ]

for i, t in enumerate(times):
    print("{:2.4f} {:+f} {}".format(t, diffs[i], labels[i]))
