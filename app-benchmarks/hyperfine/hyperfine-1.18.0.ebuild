# Copyright 2020-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
	ahash@0.7.6
	ahash@0.8.3
	aho-corasick@1.1.1
	anstream@0.6.4
	anstyle-parse@0.2.2
	anstyle-query@1.0.0
	anstyle-wincon@3.0.1
	anstyle@1.0.4
	anyhow@1.0.75
	approx@0.5.1
	arrayvec@0.7.4
	assert_cmd@2.0.12
	atty@0.2.14
	autocfg@0.1.8
	autocfg@1.1.0
	bitflags@1.3.2
	bitflags@2.4.0
	bitvec@1.0.1
	borsh-derive-internal@0.10.3
	borsh-derive@0.10.3
	borsh-schema-derive-internal@0.10.3
	borsh@0.10.3
	bstr@1.6.2
	bytecheck@0.6.11
	bytecheck_derive@0.6.11
	bytes@1.5.0
	cc@1.0.83
	cfg-if@1.0.0
	clap@4.4.6
	clap_builder@4.4.6
	clap_complete@4.4.3
	clap_lex@0.5.1
	cloudabi@0.0.3
	colorchoice@1.0.0
	colored@2.0.4
	console@0.15.7
	csv-core@0.1.11
	csv@1.3.0
	difflib@0.4.0
	doc-comment@0.3.3
	either@1.9.0
	encode_unicode@0.3.6
	errno-dragonfly@0.1.2
	errno@0.3.4
	fastrand@2.0.1
	float-cmp@0.9.0
	fuchsia-cprng@0.1.1
	funty@2.0.0
	getrandom@0.2.10
	hashbrown@0.12.3
	hashbrown@0.13.2
	hermit-abi@0.1.19
	hermit-abi@0.3.3
	indicatif@0.17.4
	instant@0.1.12
	is-terminal@0.4.9
	itertools@0.11.0
	itoa@1.0.9
	lazy_static@1.4.0
	libc@0.2.148
	linux-raw-sys@0.4.8
	memchr@2.6.4
	memoffset@0.7.1
	nix@0.26.4
	normalize-line-endings@0.3.0
	num-bigint@0.2.6
	num-complex@0.2.4
	num-integer@0.1.45
	num-iter@0.1.43
	num-rational@0.2.4
	num-traits@0.2.16
	num@0.2.1
	number_prefix@0.4.0
	once_cell@1.18.0
	pin-utils@0.1.0
	portable-atomic@1.4.3
	ppv-lite86@0.2.17
	predicates-core@1.0.6
	predicates-tree@1.0.9
	predicates@3.0.4
	proc-macro-crate@0.1.5
	proc-macro2@1.0.67
	ptr_meta@0.1.4
	ptr_meta_derive@0.1.4
	quote@1.0.33
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
	redox_syscall@0.3.5
	regex-automata@0.3.9
	regex-syntax@0.7.5
	regex@1.9.6
	rend@0.4.1
	rkyv@0.7.42
	rkyv_derive@0.7.42
	rust_decimal@1.32.0
	rustix@0.38.17
	ryu@1.0.15
	seahash@4.1.0
	serde@1.0.188
	serde_derive@1.0.188
	serde_json@1.0.107
	shell-words@1.1.0
	simdutf8@0.1.4
	statistical@1.0.0
	strsim@0.10.0
	syn@1.0.109
	syn@2.0.37
	tap@1.0.1
	tempfile@3.8.0
	terminal_size@0.3.0
	termtree@0.4.1
	thiserror-impl@1.0.49
	thiserror@1.0.49
	tinyvec@1.6.0
	tinyvec_macros@0.1.1
	toml@0.5.11
	unicode-ident@1.0.12
	unicode-width@0.1.11
	utf8parse@0.2.1
	uuid@1.4.1
	version_check@0.9.4
	wait-timeout@0.2.0
	wasi@0.11.0+wasi-snapshot-preview1
	winapi-i686-pc-windows-gnu@0.4.0
	winapi-x86_64-pc-windows-gnu@0.4.0
	winapi@0.3.9
	windows-sys@0.45.0
	windows-sys@0.48.0
	windows-targets@0.42.2
	windows-targets@0.48.5
	windows_aarch64_gnullvm@0.42.2
	windows_aarch64_gnullvm@0.48.5
	windows_aarch64_msvc@0.42.2
	windows_aarch64_msvc@0.48.5
	windows_i686_gnu@0.42.2
	windows_i686_gnu@0.48.5
	windows_i686_msvc@0.42.2
	windows_i686_msvc@0.48.5
	windows_x86_64_gnu@0.42.2
	windows_x86_64_gnu@0.48.5
	windows_x86_64_gnullvm@0.42.2
	windows_x86_64_gnullvm@0.48.5
	windows_x86_64_msvc@0.42.2
	windows_x86_64_msvc@0.48.5
	wyz@0.5.1
"

inherit bash-completion-r1 cargo

DESCRIPTION="A command-line benchmarking tool (runs other benchmarks)"
HOMEPAGE="https://github.com/sharkdp/hyperfine"
SRC_URI="
	https://github.com/sharkdp/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
	${CARGO_CRATE_URIS}
"

LICENSE="Apache-2.0"
# Dependent crate licenses
LICENSE+=" Apache-2.0 BSD-2 BSD ISC MIT MPL-2.0 Unicode-DFS-2016"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~riscv"

BDEPEND=">=virtual/rust-1.70.0"

QA_FLAGS_IGNORED="usr/bin/${PN}"

src_prepare() {
	default

	sed -i '/strip =/d' Cargo.toml || die
}

src_install() {
	local build_dir="$(dirname $(find target/ -name ${PN}.bash -print -quit))"

	newbashcomp "${build_dir}/${PN}.bash" "${PN}"

	insinto /usr/share/zsh/site-functions
	doins "${build_dir}/_${PN}"

	insinto /usr/share/fish/vendor_completions.d
	doins "${build_dir}/${PN}.fish"

	cargo_src_install
	doman doc/hyperfine.1
	einstalldocs
}
