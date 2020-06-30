# Copyright 2017-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CRATES="
autocfg-1.0.0
bitflags-1.2.1
cassowary-0.3.0
cc-1.0.55
cfg-if-0.1.10
chrono-0.4.11
either-1.5.3
getopts-0.2.21
greetd_ipc-0.6.0
itertools-0.9.0
itoa-0.4.6
libc-0.2.71
nix-0.17.0
num-integer-0.1.43
num-traits-0.2.12
numtoa-0.1.0
proc-macro2-1.0.18
quote-1.0.7
redox_syscall-0.1.56
redox_termios-0.1.1
ryu-1.0.5
serde-1.0.114
serde_derive-1.0.114
serde_json-1.0.55
syn-1.0.33
termion-1.5.5
textwrap-0.12.0
thiserror-1.0.20
thiserror-impl-1.0.20
time-0.1.43
tui-0.9.5
unicode-segmentation-1.6.0
unicode-width-0.1.7
unicode-xid-0.2.1
void-1.0.2
winapi-0.3.9
winapi-i686-pc-windows-gnu-0.4.0
winapi-x86_64-pc-windows-gnu-0.4.0
"

inherit cargo

DESCRIPTION="TUI greeter for greetd login manager"
HOMEPAGE="https://github.com/apognu/tuigreet"

COMMIT="f2ec800eed121d13c6ae247fab34b603a61bcca7"
SRC_URI="https://github.com/apognu/tuigreet/archive/${COMMIT}.tar.gz -> ${P}.tar.gz
	$(cargo_crate_uris ${CRATES})"
S="${WORKDIR}/${PN}-${COMMIT}"

LICENSE="Apache-2.0 Boost-1.0 GPL-3 MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="gui-libs/greetd"
