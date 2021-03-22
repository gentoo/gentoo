# Copyright 2017-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

CRATES="
ansi_term-0.11.0
atty-0.2.14
autocfg-1.0.1
bitflags-1.2.1
cbindgen-0.18.0
cfg-if-0.1.10
clap-2.33.3
cloudabi-0.0.3
getrandom-0.1.15
hashbrown-0.9.1
heck-0.3.1
hermit-abi-0.1.16
indexmap-1.6.0
itoa-0.4.6
lazy_static-1.4.0
libc-0.2.77
lock_api-0.3.4
log-0.4.11
parking_lot-0.10.2
parking_lot_core-0.7.2
ppv-lite86-0.2.9
proc-macro2-1.0.21
quote-1.0.7
rand-0.7.3
rand_chacha-0.2.2
rand_core-0.5.1
rand_hc-0.2.0
redox_syscall-0.1.57
remove_dir_all-0.5.3
ryu-1.0.5
scopeguard-1.1.0
serde-1.0.116
serde_derive-1.0.116
serde_json-1.0.57
serial_test-0.5.0
serial_test_derive-0.5.0
smallvec-1.4.2
strsim-0.8.0
syn-1.0.41
tempfile-3.1.0
textwrap-0.11.0
toml-0.5.6
unicode-segmentation-1.6.0
unicode-width-0.1.8
unicode-xid-0.2.1
vec_map-0.8.2
wasi-0.9.0+wasi-snapshot-preview1
winapi-0.3.9
winapi-i686-pc-windows-gnu-0.4.0
winapi-x86_64-pc-windows-gnu-0.4.0
"

inherit cargo

DESCRIPTION="A tool for generating C bindings to Rust code"
HOMEPAGE="https://github.com/eqrion/cbindgen/"
SRC_URI="$(cargo_crate_uris ${CRATES})"
LICENSE="MIT MPL-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ~ppc64 x86"
RESTRICT="test"
QA_FLAGS_IGNORED="usr/bin/cbindgen"
