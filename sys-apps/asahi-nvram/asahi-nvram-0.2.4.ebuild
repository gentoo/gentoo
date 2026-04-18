# Copyright 2024-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
	adler32@1.2.0
	aho-corasick@1.1.3
	anstream@0.6.18
	anstyle-parse@0.2.6
	anstyle-query@1.1.2
	anstyle-wincon@3.0.6
	anstyle@1.0.10
	bitflags@2.6.0
	cfg-if@1.0.0
	cfg_aliases@0.2.1
	clap@4.5.21
	clap_builder@4.5.21
	clap_derive@4.5.18
	clap_lex@0.7.3
	colorchoice@1.0.3
	const-random-macro@0.1.16
	const-random@0.1.18
	crc-catalog@2.4.0
	crc32fast@1.4.2
	crc@3.2.1
	crunchy@0.2.3
	dbus@0.9.7
	dlv-list@0.5.2
	getrandom@0.2.15
	gpt@3.1.0
	hashbrown@0.14.5
	heck@0.5.0
	is_terminal_polyfill@1.70.1
	libc@0.2.164
	libdbus-sys@0.2.5
	log@0.4.22
	memchr@2.7.4
	nix@0.29.0
	once_cell@1.20.2
	ordered-multimap@0.7.3
	pkg-config@0.3.31
	proc-macro2@1.0.92
	quote@1.0.37
	regex-automata@0.4.9
	regex-syntax@0.8.5
	regex@1.11.1
	rust-ini@0.21.1
	strsim@0.11.1
	syn@2.0.89
	tiny-keccak@2.0.2
	trim-in-place@0.1.7
	unicode-ident@1.0.14
	utf8parse@0.2.2
	uuid@1.11.0
	wasi@0.11.0+wasi-snapshot-preview1
	winapi-i686-pc-windows-gnu@0.4.0
	winapi-x86_64-pc-windows-gnu@0.4.0
	winapi@0.3.9
	windows-sys@0.59.0
	windows-targets@0.52.6
	windows_aarch64_gnullvm@0.52.6
	windows_aarch64_msvc@0.52.6
	windows_i686_gnu@0.52.6
	windows_i686_gnullvm@0.52.6
	windows_i686_msvc@0.52.6
	windows_x86_64_gnu@0.52.6
	windows_x86_64_gnullvm@0.52.6
	windows_x86_64_msvc@0.52.6
"

inherit cargo linux-info

# Releases are not tagged
COMMIT="5d70547e47232e5771f21362f3d923493dc4fa05"
MY_P="asahi-nvram-${COMMIT}"
DESCRIPTION="Tool to read and write nvram variables on ARM Macs"
HOMEPAGE="https://github.com/AsahiLinux/asahi-nvram"

SRC_URI="
	${CARGO_CRATE_URIS}
	https://github.com/AsahiLinux/asahi-nvram/archive/${COMMIT}.tar.gz -> ${P}.tar.gz
"
S="${WORKDIR}/${MY_P}/asahi-nvram"

LICENSE="MIT"
# Dependent crate licenses
LICENSE+=" MIT Unicode-DFS-2016 ZLIB"
SLOT="0"
KEYWORDS="~arm64"

pkg_setup() {
	linux-info_pkg_setup
	rust_pkg_setup
}

pkg_pretend() {
	if use kernel_linux; then
		linux_config_exists || die "No suitable kernel configuration could be found"
		CONFIG_EXTRA="~MTD_SPI_NOR"
		check_extra_config
	fi
}
