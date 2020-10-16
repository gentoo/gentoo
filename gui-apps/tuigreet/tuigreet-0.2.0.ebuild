# Copyright 2017-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CRATES="
ahash-0.3.8
autocfg-1.0.0
bitflags-1.2.1
cassowary-0.3.0
cc-1.0.59
cfg-if-0.1.10
chrono-0.4.15
dlv-list-0.2.2
getopts-0.2.21
getrandom-0.1.14
greetd_ipc-0.6.0
hashbrown-0.7.2
itoa-0.4.6
libc-0.2.74
nix-0.18.0
num-integer-0.1.43
num-traits-0.2.12
numtoa-0.1.0
ordered-multimap-0.2.4
ppv-lite86-0.2.8
proc-macro2-1.0.19
quote-1.0.7
rand-0.7.3
rand_chacha-0.2.2
rand_core-0.5.1
rand_hc-0.2.0
redox_syscall-0.1.57
redox_termios-0.1.1
rust-ini-0.15.3
ryu-1.0.5
serde-1.0.115
serde_derive-1.0.115
serde_json-1.0.57
syn-1.0.38
termion-1.5.5
textwrap-0.12.1
thiserror-1.0.20
thiserror-impl-1.0.20
time-0.1.43
tui-0.10.0
unicode-segmentation-1.6.0
unicode-width-0.1.8
unicode-xid-0.2.1
wasi-0.9.0+wasi-snapshot-preview1
winapi-0.3.9
winapi-i686-pc-windows-gnu-0.4.0
winapi-x86_64-pc-windows-gnu-0.4.0
zeroize-1.1.0
"

inherit cargo

DESCRIPTION="TUI greeter for greetd login manager"
HOMEPAGE="https://github.com/apognu/tuigreet"

SRC_URI="https://github.com/apognu/tuigreet/archive/${PV}.tar.gz -> ${P}.tar.gz
	$(cargo_crate_uris ${CRATES})"

QA_FLAGS_IGNORED="usr/bin/tuigreet"

LICENSE="Apache-2.0 Boost-1.0 GPL-3 MIT"
SLOT="0"
KEYWORDS="~amd64 ~ppc64"

RDEPEND="gui-libs/greetd"
