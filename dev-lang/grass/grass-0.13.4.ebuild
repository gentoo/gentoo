# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
	ahash@0.8.7
	anstream@0.6.11
	anstyle-parse@0.2.3
	anstyle-query@1.0.2
	anstyle-wincon@3.0.2
	anstyle@1.0.6
	bitflags@2.4.2
	bumpalo@3.14.0
	cfg-if@1.0.0
	clap@4.4.18
	clap_builder@4.4.18
	clap_lex@0.6.0
	codemap@0.1.3
	colorchoice@1.0.0
	equivalent@1.0.1
	errno@0.3.8
	fastrand@2.0.1
	getrandom@0.2.12
	hashbrown@0.13.2
	hashbrown@0.14.3
	indexmap@2.2.2
	js-sys@0.3.68
	lasso@0.7.2
	libc@0.2.153
	linux-raw-sys@0.4.13
	log@0.4.20
	once_cell@1.19.0
	paste@1.0.14
	phf@0.11.2
	phf_generator@0.11.2
	phf_macros@0.11.2
	phf_shared@0.11.2
	ppv-lite86@0.2.17
	proc-macro2@1.0.78
	quote@1.0.35
	rand@0.8.5
	rand_chacha@0.3.1
	rand_core@0.6.4
	rustix@0.38.31
	siphasher@0.3.11
	strsim@0.10.0
	syn@2.0.48
	tempfile@3.10.0
	unicode-ident@1.0.12
	utf8parse@0.2.1
	version_check@0.9.4
	wasi@0.11.0+wasi-snapshot-preview1
	wasm-bindgen-backend@0.2.91
	wasm-bindgen-macro-support@0.2.91
	wasm-bindgen-macro@0.2.91
	wasm-bindgen-shared@0.2.91
	wasm-bindgen@0.2.91
	windows-sys@0.52.0
	windows-targets@0.52.0
	windows_aarch64_gnullvm@0.52.0
	windows_aarch64_msvc@0.52.0
	windows_i686_gnu@0.52.0
	windows_i686_msvc@0.52.0
	windows_x86_64_gnu@0.52.0
	windows_x86_64_gnullvm@0.52.0
	windows_x86_64_msvc@0.52.0
	zerocopy-derive@0.7.32
	zerocopy@0.7.32
"

inherit cargo

DESCRIPTION="A Sass compiler written purely in Rust"
HOMEPAGE="https://github.com/connorskees/grass"
SRC_URI="
	https://github.com/connorskees/grass/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz
	${CARGO_CRATE_URIS}
"
S=${WORKDIR}/${P}/crates/lib

LICENSE="MIT"
# Dependent crate licenses
LICENSE+=" MIT Unicode-DFS-2016"
SLOT="0"
KEYWORDS="amd64 arm64"

QA_FLAGS_IGNORED="/usr/bin/grass"

src_install() {
	cargo_src_install
	dodoc ../../{CHANGELOG.md,README.md}
}
