# Copyright 2020-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

RUST_MIN_VER="1.88.0"

CRATES="
	ahash@0.7.8
	aho-corasick@1.1.4
	anstream@0.6.21
	anstyle-parse@0.2.7
	anstyle-query@1.1.5
	anstyle-wincon@3.0.11
	anstyle@1.0.13
	anyhow@1.0.100
	approx@0.5.1
	arrayvec@0.7.6
	assert_cmd@2.1.1
	autocfg@0.1.8
	autocfg@1.5.0
	bitflags@1.3.2
	bitflags@2.10.0
	bitvec@1.0.1
	borsh-derive@1.5.7
	borsh@1.5.7
	bstr@1.12.1
	bumpalo@3.19.0
	bytecheck@0.6.12
	bytecheck_derive@0.6.12
	bytes@1.11.0
	cfg-if@1.0.4
	cfg_aliases@0.2.1
	clap@4.5.52
	clap_builder@4.5.52
	clap_complete@4.5.60
	clap_lex@0.7.6
	cloudabi@0.0.3
	colorchoice@1.0.4
	colored@2.2.0
	console@0.15.11
	csv-core@0.1.13
	csv@1.4.0
	difflib@0.4.0
	encode_unicode@1.0.0
	equivalent@1.0.2
	errno@0.3.14
	fastrand@2.3.0
	float-cmp@0.10.0
	fuchsia-cprng@0.1.1
	funty@2.0.0
	getrandom@0.2.16
	getrandom@0.3.4
	hashbrown@0.12.3
	hashbrown@0.16.0
	indexmap@2.12.0
	indicatif@0.17.4
	insta@1.43.2
	instant@0.1.13
	is_terminal_polyfill@1.70.2
	itoa@1.0.15
	js-sys@0.3.82
	lazy_static@1.5.0
	libc@0.2.177
	linux-raw-sys@0.11.0
	memchr@2.7.6
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
	once_cell@1.21.3
	once_cell_polyfill@1.70.2
	portable-atomic@1.11.1
	ppv-lite86@0.2.21
	predicates-core@1.0.9
	predicates-tree@1.0.12
	predicates@3.1.3
	proc-macro-crate@3.4.0
	proc-macro2@1.0.103
	ptr_meta@0.1.4
	ptr_meta_derive@0.1.4
	quote@1.0.42
	r-efi@5.3.0
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
	regex-automata@0.4.13
	regex-syntax@0.8.8
	regex@1.12.2
	rend@0.4.2
	rkyv@0.7.45
	rkyv_derive@0.7.45
	rust_decimal@1.39.0
	rustix@1.1.2
	rustversion@1.0.22
	ryu@1.0.20
	seahash@4.1.0
	serde@1.0.228
	serde_core@1.0.228
	serde_derive@1.0.228
	serde_json@1.0.145
	shell-words@1.1.0
	simdutf8@0.1.5
	similar@2.7.0
	statistical@1.0.0
	strsim@0.11.1
	syn@1.0.109
	syn@2.0.110
	tap@1.0.1
	tempfile@3.23.0
	terminal_size@0.4.3
	termtree@0.5.1
	thiserror-impl@2.0.17
	thiserror@2.0.17
	tinyvec@1.10.0
	tinyvec_macros@0.1.1
	toml_datetime@0.7.3
	toml_edit@0.23.7
	toml_parser@1.0.4
	unicode-ident@1.0.22
	unicode-width@0.1.14
	unicode-width@0.2.2
	utf8parse@0.2.2
	uuid@1.18.1
	version_check@0.9.5
	wait-timeout@0.2.1
	wasi@0.11.1+wasi-snapshot-preview1
	wasip2@1.0.1+wasi-0.2.4
	wasm-bindgen-macro-support@0.2.105
	wasm-bindgen-macro@0.2.105
	wasm-bindgen-shared@0.2.105
	wasm-bindgen@0.2.105
	winapi-i686-pc-windows-gnu@0.4.0
	winapi-x86_64-pc-windows-gnu@0.4.0
	winapi@0.3.9
	windows-link@0.2.1
	windows-sys@0.59.0
	windows-sys@0.60.2
	windows-sys@0.61.2
	windows-targets@0.52.6
	windows-targets@0.53.5
	windows_aarch64_gnullvm@0.52.6
	windows_aarch64_gnullvm@0.53.1
	windows_aarch64_msvc@0.52.6
	windows_aarch64_msvc@0.53.1
	windows_i686_gnu@0.52.6
	windows_i686_gnu@0.53.1
	windows_i686_gnullvm@0.52.6
	windows_i686_gnullvm@0.53.1
	windows_i686_msvc@0.52.6
	windows_i686_msvc@0.53.1
	windows_x86_64_gnu@0.52.6
	windows_x86_64_gnu@0.53.1
	windows_x86_64_gnullvm@0.52.6
	windows_x86_64_gnullvm@0.53.1
	windows_x86_64_msvc@0.52.6
	windows_x86_64_msvc@0.53.1
	winnow@0.7.13
	wit-bindgen@0.46.0
	wyz@0.5.1
	zerocopy-derive@0.8.27
	zerocopy@0.8.27
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
LICENSE+=" Apache-2.0 BSD-2 BSD ISC MIT MPL-2.0 Unicode-3.0"
SLOT="0"
KEYWORDS="amd64 ~arm64 ~ppc64 ~riscv"

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
