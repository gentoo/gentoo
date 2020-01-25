# Copyright 2017-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

CRATES="
ansi_term-0.11.0
atty-0.2.13
bitflags-1.2.1
c2-chacha-0.2.3
cbindgen-0.12.1
cfg-if-0.1.10
clap-2.33.0
getrandom-0.1.13
itoa-0.4.4
libc-0.2.66
log-0.4.8
ppv-lite86-0.2.6
proc-macro2-1.0.6
quote-1.0.2
rand-0.7.2
rand_chacha-0.2.1
rand_core-0.5.1
rand_hc-0.2.0
redox_syscall-0.1.56
remove_dir_all-0.5.2
ryu-1.0.2
serde-1.0.104
serde_derive-1.0.104
serde_json-1.0.44
strsim-0.8.0
syn-1.0.11
tempfile-3.1.0
textwrap-0.11.0
toml-0.5.5
unicode-width-0.1.7
unicode-xid-0.2.0
vec_map-0.8.1
wasi-0.7.0
winapi-0.3.8
winapi-i686-pc-windows-gnu-0.4.0
winapi-x86_64-pc-windows-gnu-0.4.0
"

inherit cargo

DESCRIPTION="A tool for generating C bindings to Rust code"
HOMEPAGE="https://github.com/eqrion/cbindgen/"
SRC_URI="$(cargo_crate_uris ${CRATES})"
LICENSE="MIT MPL-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~x86"
