# Copyright 2020-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
	ahash@0.7.8
	aho-corasick@1.1.3
	anstream@0.6.18
	anstyle-parse@0.2.6
	anstyle-query@1.1.2
	anstyle-wincon@3.0.6
	anstyle@1.0.10
	anyhow@1.0.93
	approx@0.5.1
	arrayvec@0.7.6
	assert_cmd@2.0.16
	autocfg@0.1.8
	autocfg@1.4.0
	bitflags@1.3.2
	bitflags@2.6.0
	bitvec@1.0.1
	borsh-derive@1.5.2
	borsh@1.5.2
	bstr@1.10.0
	bytecheck@0.6.12
	bytecheck_derive@0.6.12
	byteorder@1.5.0
	bytes@1.8.0
	cfg-if@1.0.0
	cfg_aliases@0.2.1
	clap@4.5.20
	clap_builder@4.5.20
	clap_complete@4.5.37
	clap_lex@0.7.2
	cloudabi@0.0.3
	colorchoice@1.0.3
	colored@2.1.0
	console@0.15.8
	csv-core@0.1.11
	csv@1.3.1
	difflib@0.4.0
	doc-comment@0.3.3
	encode_unicode@0.3.6
	equivalent@1.0.1
	errno@0.3.9
	fastrand@2.2.0
	float-cmp@0.9.0
	fuchsia-cprng@0.1.1
	funty@2.0.0
	getrandom@0.2.15
	hashbrown@0.12.3
	hashbrown@0.15.1
	indexmap@2.6.0
	indicatif@0.17.4
	instant@0.1.13
	is_terminal_polyfill@1.70.1
	itoa@1.0.11
	lazy_static@1.5.0
	libc@0.2.162
	linux-raw-sys@0.4.14
	memchr@2.7.4
	nix@0.29.0
	normalize-line-endings@0.3.0
	num-bigint@0.2.6
	num-complex@0.2.4
	num-integer@0.1.46
	num-iter@0.1.45
	num-rational@0.2.4
	num-traits@0.2.19
	num@0.2.1
	number_prefix@0.4.0
	once_cell@1.20.2
	portable-atomic@1.9.0
	ppv-lite86@0.2.20
	predicates-core@1.0.8
	predicates-tree@1.0.11
	predicates@3.1.2
	proc-macro-crate@3.2.0
	proc-macro2@1.0.89
	ptr_meta@0.1.4
	ptr_meta_derive@0.1.4
	quote@1.0.37
	radium@0.7.0
	rand@0.6.5
	rand@0.8.5
	rand_chacha@0.1.1
	rand_chacha@0.3.1
	rand_core@0.3.1
	rand_core@0.4.2
	rand_core@0.6.4
	rand_hc@0.1.0
	rand_isaac@0.1.1
	rand_jitter@0.1.4
	rand_os@0.1.3
	rand_pcg@0.1.2
	rand_xorshift@0.1.1
	rdrand@0.4.0
	regex-automata@0.4.8
	regex-syntax@0.8.5
	regex@1.11.1
	rend@0.4.2
	rkyv@0.7.45
	rkyv_derive@0.7.45
	rust_decimal@1.36.0
	rustix@0.38.40
	ryu@1.0.18
	seahash@4.1.0
	serde@1.0.214
	serde_derive@1.0.214
	serde_json@1.0.132
	shell-words@1.1.0
	simdutf8@0.1.5
	statistical@1.0.0
	strsim@0.11.1
	syn@1.0.109
	syn@2.0.87
	tap@1.0.1
	tempfile@3.14.0
	terminal_size@0.4.0
	termtree@0.4.1
	thiserror-impl@2.0.3
	thiserror@2.0.3
	tinyvec@1.8.0
	tinyvec_macros@0.1.1
	toml_datetime@0.6.8
	toml_edit@0.22.22
	unicode-ident@1.0.13
	unicode-width@0.1.14
	utf8parse@0.2.2
	uuid@1.11.0
	version_check@0.9.5
	wait-timeout@0.2.0
	wasi@0.11.0+wasi-snapshot-preview1
	winapi-i686-pc-windows-gnu@0.4.0
	winapi-x86_64-pc-windows-gnu@0.4.0
	winapi@0.3.9
	windows-sys@0.48.0
	windows-sys@0.52.0
	windows-sys@0.59.0
	windows-targets@0.48.5
	windows-targets@0.52.6
	windows_aarch64_gnullvm@0.48.5
	windows_aarch64_gnullvm@0.52.6
	windows_aarch64_msvc@0.48.5
	windows_aarch64_msvc@0.52.6
	windows_i686_gnu@0.48.5
	windows_i686_gnu@0.52.6
	windows_i686_gnullvm@0.52.6
	windows_i686_msvc@0.48.5
	windows_i686_msvc@0.52.6
	windows_x86_64_gnu@0.48.5
	windows_x86_64_gnu@0.52.6
	windows_x86_64_gnullvm@0.48.5
	windows_x86_64_gnullvm@0.52.6
	windows_x86_64_msvc@0.48.5
	windows_x86_64_msvc@0.52.6
	winnow@0.6.20
	wyz@0.5.1
	zerocopy-derive@0.7.35
	zerocopy@0.7.35
"

inherit shell-completion cargo

DESCRIPTION="A command-line benchmarking tool"
HOMEPAGE="https://github.com/sharkdp/hyperfine"
SRC_URI="
	https://github.com/sharkdp/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
	${CARGO_CRATE_URIS}
"

LICENSE="|| ( Apache-2.0 MIT )"
# Dependent crate licenses
LICENSE+=" Apache-2.0 BSD-2 BSD ISC MIT MPL-2.0 Unicode-DFS-2016"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~riscv"

QA_FLAGS_IGNORED="usr/bin/${PN}"

src_prepare() {
	default

	sed -i '/strip =/d' Cargo.toml || die
}

src_install() {
	cargo_src_install

	local build_dir="$(dirname $(find "$(cargo_target_dir)" -name ${PN}.bash -print -quit))"
	newbashcomp "${build_dir}/${PN}.bash" "${PN}"
	dozshcomp "${build_dir}/_${PN}"
	dofishcomp "${build_dir}/${PN}.fish"

	doman doc/hyperfine.1
	einstalldocs
}
