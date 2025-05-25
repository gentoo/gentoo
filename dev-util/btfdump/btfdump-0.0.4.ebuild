# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
	adler2@2.0.0
	aho-corasick@1.1.3
	anstream@0.6.18
	anstyle-parse@0.2.6
	anstyle-query@1.1.2
	anstyle-wincon@3.0.7
	anstyle@1.0.10
	bitflags@2.9.0
	byteorder@1.5.0
	cfg-if@1.0.0
	clap@4.5.37
	clap_builder@4.5.37
	clap_derive@4.5.32
	clap_lex@0.7.4
	colorchoice@1.0.3
	crc32fast@1.4.2
	derive_more@0.99.19
	errno@0.3.11
	flate2@1.1.1
	goblin@0.7.1
	heck@0.5.0
	is_terminal_polyfill@1.70.1
	lazy_static@1.5.0
	libc@0.2.172
	linux-raw-sys@0.9.4
	log@0.4.27
	memchr@2.7.4
	memmap@0.7.0
	miniz_oxide@0.8.8
	object@0.32.2
	once_cell@1.21.3
	plain@0.2.3
	proc-macro2@1.0.95
	quote@1.0.40
	regex-automata@0.4.9
	regex-syntax@0.8.5
	regex@1.11.1
	rustix@1.0.5
	ruzstd@0.5.0
	scroll@0.11.0
	scroll_derive@0.11.1
	static_assertions@1.1.0
	strsim@0.11.1
	syn@2.0.100
	terminal_size@0.4.2
	twox-hash@1.6.3
	unicode-ident@1.0.18
	utf8parse@0.2.2
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

inherit cargo

DESCRIPTION="BTF introspection tool"
HOMEPAGE="https://github.com/anakryiko/btfdump/"
SRC_URI="
	https://github.com/anakryiko/btfdump/archive/v${PV}.tar.gz
		-> ${P}.tar.gz
	${CARGO_CRATE_URIS}
"

LICENSE="BSD-2"
# Dependent crate licenses
LICENSE+=" MIT Unicode-3.0"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

QA_FLAGS_IGNORED="/usr/bin/btf"
