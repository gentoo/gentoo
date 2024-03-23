# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
	adler32@1.2.0
	ahash@0.7.6
	anstream@0.6.4
	anstyle-parse@0.2.3
	anstyle-query@1.0.1
	anstyle-wincon@3.0.2
	anstyle@1.0.4
	atty@0.2.14
	autocfg@1.1.0
	bitflags@1.3.2
	bitflags@2.3.3
	cfg-if@1.0.0
	clap@3.2.25
	clap@4.4.11
	clap_builder@4.4.11
	clap_derive@4.4.7
	clap_lex@0.2.4
	clap_lex@0.6.0
	colorchoice@1.0.0
	crc-catalog@2.2.0
	crc32fast@1.3.2
	crc@3.0.1
	dlv-list@0.3.0
	getrandom@0.2.10
	gpt@3.1.0
	hashbrown@0.12.3
	heck@0.4.1
	hermit-abi@0.1.19
	indexmap@1.9.3
	libc@0.2.147
	log@0.4.19
	memoffset@0.7.1
	nix@0.26.2
	once_cell@1.18.0
	ordered-multimap@0.4.3
	os_str_bytes@6.5.1
	pin-utils@0.1.0
	proc-macro2@1.0.70
	quote@1.0.33
	rust-ini@0.18.0
	static_assertions@1.1.0
	strsim@0.10.0
	syn@2.0.39
	termcolor@1.2.0
	textwrap@0.16.0
	unicode-ident@1.0.12
	utf8parse@0.2.1
	uuid@1.4.0
	version_check@0.9.4
	wasi@0.11.0+wasi-snapshot-preview1
	winapi-i686-pc-windows-gnu@0.4.0
	winapi-util@0.1.5
	winapi-x86_64-pc-windows-gnu@0.4.0
	winapi@0.3.9
	windows-sys@0.52.0
	windows-targets@0.52.0
	windows_aarch64_gnullvm@0.52.0
	windows_aarch64_msvc@0.52.0
	windows_i686_gnu@0.52.0
	windows_i686_msvc@0.52.0
	windows_x86_64_gnu@0.52.0
	windows_x86_64_gnullvm@0.52.0
	windows_x86_64_msvc@0.52.0
"

inherit cargo linux-info

# Releases are not tagged
COMMIT="6764bf5fbe6371a70604cc58aaa6d6b4473b3adf"
MY_P="asahi-nvram-${COMMIT}"
DESCRIPTION="Tool to read and write nvram variables on ARM Macs"
HOMEPAGE="https://github.com/WhatAmISupposedToPutHere/asahi-nvram"

SRC_URI="
	${CARGO_CRATE_URIS}
	https://github.com/WhatAmISupposedToPutHere/asahi-nvram/archive/${COMMIT}.tar.gz -> ${P}.tar.gz
"
S="${WORKDIR}/${MY_P}/asahi-nvram"

LICENSE="MIT"
# Dependent crate licenses
LICENSE+=" MIT Unicode-DFS-2016 ZLIB"
SLOT="0"
KEYWORDS="~arm64"

pkg_pretend() {
	if use kernel_linux; then
		linux_config_exists || die "No suitable kernel configuration could be found"
		CONFIG_EXTRA="~MTD_SPI_NOR"
		check_extra_config
	fi
}
