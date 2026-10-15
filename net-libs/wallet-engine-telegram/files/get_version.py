#!/usr/bin/env python3
# Version checking script for telegram's wallet-engine patch
# Can be used as an nvchecker source

import json
import tomllib
import yaml
from datetime import datetime

snap_url = "https://raw.githubusercontent.com/telegramdesktop/tdesktop/refs/heads/dev/snap/snapcraft.yaml"

patch_url = "https://api.github.com/repos/desktop-app/patches/commits?path=wallet-engine.patch"
commit_url = "https://api.github.com/repos/i582/wallet-engine/commits/%s"
cargo_url = "https://raw.githubusercontent.com/i582/wallet-engine/%s/Cargo.toml"

def parse_rev(res):
    return yaml.safe_load(res)["parts"]["wallet-engine"]["source-commit"]

def parse(rev, patch_res, commit_res, cargo_res):
    patch_res = json.loads(patch_res)[0]
    patches_date = datetime.fromisoformat(patch_res["commit"]["committer"]["date"])
    my_date = datetime.fromisoformat(json.loads(commit_res)["commit"]["committer"]["date"])
    pv = tomllib.loads(cargo_res.decode())["workspace"]["package"]["version"]
    return {
        "version": "%s_p%s" % (pv, max(my_date, patches_date).strftime("%Y%m%d")),
        "revision": " ".join((rev, patch_res["sha"])),
    }

if __name__ == "__main__":
    from urllib.request import urlopen
    rev = parse_rev(urlopen(snap_url).read())
    res = parse(rev,
        urlopen(patch_url).read(),
        urlopen(commit_url % rev).read(),
        urlopen(cargo_url % rev).read())
    print(res["version"])
    print("MY_PV=\"%s\"" % res["revision"].split(" ")[0])
    print("PATCHES_PV=\"%s\"" % res["revision"].split(" ")[1])
else:
    from nvchecker.api import *

    async def get_version(name, conf, *, cache, **kwargs):
        key = tuple(sorted(conf.items()))
        return await cache.get(key, get_version_impl)

    async def get_version_impl(info):
        snap_res = await session.get(snap_url)
        rev = parse_rev(snap_res.body)
        patch_res = await session.get(patch_url)
        commit_res = await session.get(commit_url % rev)
        cargo_res = await session.get(cargo_url % rev)
        return RichResult(**parse(rev, patch_res.body, commit_res.body, cargo_res.body))
