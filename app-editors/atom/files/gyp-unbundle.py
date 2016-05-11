#!/usr/bin/env python

from __future__ import print_function


import argparse
import sys


def die(msg):
    print(msg, file=sys.stderr)
    sys.exit(1)


def do_unbundle(gypdata, targets):
    gyptargets = {t['target_name']: t for t in gypdata['targets']}
    dropped_deps = set()

    def _unbundle_in_block(gypblock):
        gypdeps = gypblock.get('dependencies') or {}

        for dep, libs in unbundlings.items():
            if dep not in gypdeps:
                continue

            gypdeps.remove(dep)

            try:
                ls = gyptarget['link_settings']
            except KeyError:
                ls = gyptarget['link_settings'] = {}

            try:
                gyplibs = ls['libraries']
            except KeyError:
                gyplibs = ls['libraries'] = []

            gyplibs.extend('-l{}'.format(lib) for lib in libs)

            dropped_deps.add(dep)

        gypconds = gypblock.get('conditions') or []
        for cond in gypconds:
            condblocks = cond[1:]
            for condblock in condblocks:
                _unbundle_in_block(condblock)

    for target, unbundlings in targets.items():
        if target not in gyptargets:
            die('There is no {} target in gyp file'.format(target))

        gyptarget = gyptargets[target]

        _unbundle_in_block(gyptarget)

    for gyptarget in gypdata['targets']:
        if gyptarget['target_name'] in dropped_deps:
            if gyptarget.get('dependencies'):
                dropped_deps.update(gyptarget.get('dependencies'))

    new_targets = []
    for gyptarget in gypdata['targets']:
        if gyptarget['target_name'] not in dropped_deps:
            new_targets.append(gyptarget)

    gypdata['targets'] = new_targets

    gypconds = gypdata.get('conditions')
    if gypconds:
        for cond in gypconds:
            condblocks = cond[1:]
            for condblock in condblocks:
                new_targets = []
                blocktargets = condblock.get('targets')
                if blocktargets:
                    for blocktarget in blocktargets:
                        if blocktarget['target_name'] not in dropped_deps:
                            new_targets.append(blocktarget)
                    condblock['targets'] = new_targets


def main():
    parser = argparse.ArgumentParser(description='Unbundle libs in gyp files')
    parser.add_argument('gypfile', type=str, help='input gyp file')
    parser.add_argument(
        '--unbundle', type=str, action='append',
        help='unbundle rule in the format <target>;<dep>;<lib>[;lib]')
    parser.add_argument(
        '-i', '--inplace', action='store_true',
        help='modify gyp file in-place')

    args = parser.parse_args()

    targets = {}

    for unbundle in args.unbundle:
        rule = unbundle.split(';')
        if len(rule) < 3:
            die('Invalid unbundle rule: {!r}'.format(unbundle))
        target, dep = rule[:2]
        libs = rule[2:]

        try:
            target_unbundlings = targets[target]
        except KeyError:
            target_unbundlings = targets[target] = {}

        target_unbundlings[dep] = libs

    with open(args.gypfile, 'rt') as f:
        gypdata = eval(f.read())

    do_unbundle(gypdata, targets)

    if args.inplace:
        with open(args.gypfile, 'wt') as f:
            f.write(repr(gypdata) + "\n")
    else:
        print(repr(gypdata))


if __name__ == '__main__':
    main()
