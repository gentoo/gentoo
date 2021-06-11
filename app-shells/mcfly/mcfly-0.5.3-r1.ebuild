# Copyright 2017-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CRATES="
aho-corasick-0.7.10
ansi_term-0.11.0
arrayref-0.3.6
arrayvec-0.5.1
atty-0.2.14
autocfg-1.0.0
base64-0.11.0
bitflags-1.2.1
blake2b_simd-0.5.10
bstr-0.2.12
byteorder-1.3.4
cc-1.0.52
cfg-if-0.1.10
clap-2.33.0
constant_time_eq-0.1.5
crossbeam-utils-0.7.2
csv-1.1.3
csv-core-0.1.10
dirs-2.0.2
dirs-sys-0.3.4
either-1.6.1
getrandom-0.1.14
hermit-abi-0.1.12
itertools-0.9.0
itoa-0.4.5
lazy_static-1.4.0
libc-0.2.69
libsqlite3-sys-0.10.0
linked-hash-map-0.5.3
lru-cache-0.1.2
memchr-2.3.3
numtoa-0.1.0
pkg-config-0.3.17
ppv-lite86-0.2.6
rand-0.7.3
rand_chacha-0.2.2
rand_core-0.5.1
rand_hc-0.2.0
redox_syscall-0.1.56
redox_termios-0.1.1
redox_users-0.3.4
regex-1.3.7
regex-automata-0.1.9
regex-syntax-0.6.17
relative-path-1.0.0
rusqlite-0.15.0
rust-argon2-0.7.0
ryu-1.0.4
serde-1.0.106
shellexpand-2.0.0
strsim-0.8.0
termion-1.5.5
textwrap-0.11.0
thread_local-1.0.1
time-0.1.43
unicode-segmentation-1.6.0
unicode-width-0.1.7
vcpkg-0.2.8
vec_map-0.8.2
wasi-0.9.0+wasi-snapshot-preview1
winapi-0.3.8
winapi-i686-pc-windows-gnu-0.4.0
winapi-x86_64-pc-windows-gnu-0.4.0
"

inherit cargo

DESCRIPTION="Context-aware bash history search replacement (ctrl-r)"
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
	doins "${PN}".{bash,fish,zsh}

	einstalldocs
}

pkg_postinst() {

	elog "To start using ${PN}, add the following to your shell:"
	elog
	elog "~/.bashrc"
	local p="${EPREFIX}/usr/share/${PN}/${PN}.bash"
	elog "[[ -f ${p} ]] && source ${p}"
	elog
	elog "~/.config/fish/config.fish"
	local p="${EPREFIX}/usr/share/${PN}/${PN}.fish"
	elog "if test -r ${p}"
	elog "    source ${p}"
	elog "    mcfly_key_bindings"
	elog
	elog "~/.zsh"
	local p="${EPREFIX}/usr/share/${PN}/${PN}.zsh"
	elog "[[ -f ${p} ]] && source ${p}"
}
