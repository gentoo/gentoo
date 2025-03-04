# Copyright 2024-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
	adler32@1.2.0
	ahash@0.7.8
	anstream@0.6.18
	anstyle-parse@0.2.6
	anstyle-query@1.1.2
	anstyle-wincon@3.0.6
	anstyle@1.0.10
	atty@0.2.14
	autocfg@1.4.0
	bitflags@1.3.2
	bitflags@2.6.0
	cfg-if@1.0.0
	clap@3.2.25
	clap@4.5.21
	clap_builder@4.5.21
	clap_derive@4.5.18
	clap_lex@0.2.4
	clap_lex@0.7.3
	colorchoice@1.0.3
	crc-catalog@2.4.0
	crc32fast@1.4.2
	crc@3.2.1
	dlv-list@0.3.0
	getrandom@0.2.15
	gpt@3.1.0
	hashbrown@0.12.3
	heck@0.5.0
	hermit-abi@0.1.19
	indexmap@1.9.3
	is_terminal_polyfill@1.70.1
	libc@0.2.164
	log@0.4.22
	memoffset@0.7.1
	nix@0.26.4
	once_cell@1.20.2
	ordered-multimap@0.4.3
	os_str_bytes@6.6.1
	pin-utils@0.1.0
	proc-macro2@1.0.92
	quote@1.0.37
	rust-ini@0.18.0
	strsim@0.10.0
	strsim@0.11.1
	syn@2.0.89
	termcolor@1.4.1
	textwrap@0.16.1
	unicode-ident@1.0.14
	utf8parse@0.2.2
	uuid@1.11.0
	version_check@0.9.5
	wasi@0.11.0+wasi-snapshot-preview1
	winapi-i686-pc-windows-gnu@0.4.0
	winapi-util@0.1.9
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
COMMIT="9b4c2942093204601bb4b0181b3d5e5bdfc2a4a3"
MY_P="asahi-nvram-${COMMIT}"
DESCRIPTION="CLI boot disk selector for Apple Silicon Macs"
HOMEPAGE="https://github.com/AsahiLinux/asahi-nvram"

SRC_URI="
	${CARGO_CRATE_URIS}
	https://github.com/AsahiLinux/asahi-nvram/archive/${COMMIT}.tar.gz -> ${P}.tar.gz
"
S="${WORKDIR}/${MY_P}/asahi-bless"

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
