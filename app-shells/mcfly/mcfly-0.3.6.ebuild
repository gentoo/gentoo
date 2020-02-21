# Copyright 2017-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CRATES="
ansi_term-0.11.0
argon2rs-0.2.5
arrayvec-0.4.7
atty-0.2.10
backtrace-0.3.9
backtrace-sys-0.1.24
bitflags-1.0.3
blake2-rfc-0.2.18
cc-1.0.18
cfg-if-0.1.5
clap-2.32.0
cloudabi-0.0.3
constant_time_eq-0.1.3
csv-1.0.1
csv-core-0.1.4
dirs-1.0.4
failure-0.1.2
failure_derive-0.1.2
fuchsia-zircon-0.3.3
fuchsia-zircon-sys-0.3.3
libc-0.2.42
libsqlite3-sys-0.10.0
linked-hash-map-0.4.2
lru-cache-0.1.1
memchr-2.0.1
nodrop-0.1.12
pkg-config-0.3.11
proc-macro2-0.4.20
quote-0.6.8
rand-0.4.3
rand-0.5.5
rand_core-0.2.1
redox_syscall-0.1.40
redox_termios-0.1.1
redox_users-0.2.0
relative-path-0.4.0
rusqlite-0.15.0
rustc-demangle-0.1.9
scoped_threadpool-0.1.9
serde-1.0.75
shellexpand-1.0.0
strsim-0.7.0
syn-0.14.9
synstructure-0.9.0
termion-1.5.1
textwrap-0.10.0
time-0.1.40
unicode-segmentation-1.2.1
unicode-width-0.1.5
unicode-xid-0.1.0
vcpkg-0.2.4
vec_map-0.8.1
winapi-0.3.5
winapi-i686-pc-windows-gnu-0.4.0
winapi-x86_64-pc-windows-gnu-0.4.0
"

inherit cargo

DESCRIPTION="Context-aware bash history search replacement (crtl-r)"
HOMEPAGE="https://github.com/cantino/mcfly"
SRC_URI="https://github.com/cantino/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
	$(cargo_crate_uris ${CRATES})"

LICENSE="Apache-2.0 BSD BSD-2 CC0-1.0 MIT Unlicense"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="dev-db/sqlite:3"
RDEPEND="${DEPEND}"

QA_FLAGS_IGNORED="/usr/bin/mcfly"

src_install() {
	cargo_src_install

	insinto "/usr/share/${PN}"
	doins "${PN}.bash"

	einstalldocs
}

pkg_postinst() {
	local p="/usr/share/${PN}/${PN}.bash"

	elog "To start using ${PN}"
	elog "Add the following to your ~/.bashrc"
	elog
	elog "[[ -f ${p} ]] && source ${p}"
}
