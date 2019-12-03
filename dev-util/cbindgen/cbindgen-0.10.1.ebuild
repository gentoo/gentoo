# Copyright 2017-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

CRATES="
ansi_term-0.11.0
atty-0.2.11
autocfg-0.1.4
bitflags-1.1.0
cbindgen-0.10.1
cfg-if-0.1.9
clap-2.33.0
cloudabi-0.0.3
fuchsia-cprng-0.1.1
itoa-0.4.4
libc-0.2.58
log-0.4.6
numtoa-0.1.0
proc-macro2-1.0.0
quote-1.0.0
rand-0.6.5
rand_chacha-0.1.1
rand_core-0.3.1
rand_core-0.4.0
rand_hc-0.1.0
rand_isaac-0.1.1
rand_jitter-0.1.4
rand_os-0.1.3
rand_pcg-0.1.2
rand_xorshift-0.1.1
rdrand-0.4.0
redox_syscall-0.1.54
redox_termios-0.1.1
remove_dir_all-0.5.2
ryu-0.2.8
serde-1.0.93
serde_derive-1.0.99
serde_json-1.0.39
strsim-0.8.0
syn-1.0.1
tempfile-3.0.8
termion-1.5.3
textwrap-0.11.0
toml-0.5.1
unicode-width-0.1.5
unicode-xid-0.2.0
vec_map-0.8.1
winapi-0.3.7
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
