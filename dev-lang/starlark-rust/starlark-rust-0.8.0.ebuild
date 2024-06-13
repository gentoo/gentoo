# Copyright 2022-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
	Inflector@0.11.4
	ahash@0.7.6
	aho-corasick@0.7.18
	annotate-snippets@0.9.1
	ansi_term@0.12.1
	anyhow@1.0.57
	argfile@0.1.4
	ascii-canvas@3.0.0
	atty@0.2.14
	autocfg@1.1.0
	beef@0.5.1
	bit-set@0.5.2
	bit-vec@0.6.3
	bitflags@1.3.2
	bumpalo@3.9.1
	cc@1.0.73
	cfg-if@1.0.0
	clap@2.34.0
	clipboard-win@4.4.1
	convert_case@0.4.0
	crossbeam-channel@0.5.4
	crossbeam-utils@0.8.8
	crunchy@0.2.2
	debugserver-types@0.5.0
	derivative@2.2.0
	derive_more@0.99.17
	diff@0.1.12
	dirs-next@2.0.0
	dirs-sys-next@0.1.2
	either@1.6.1
	ena@0.14.0
	endian-type@0.1.2
	erased-serde@0.3.20
	errno@0.2.8
	errno-dragonfly@0.1.2
	error-code@2.3.1
	fancy-regex@0.5.0
	fd-lock@3.0.5
	fixedbitset@0.4.1
	fnv@1.0.7
	form_urlencoded@1.0.1
	gazebo@0.7.0
	gazebo_derive@0.7.0
	gazebo_lint@0.1.1
	getrandom@0.2.6
	hashbrown@0.11.2
	heck@0.3.3
	hermit-abi@0.1.19
	idna@0.2.3
	indenter@0.3.3
	indexmap@1.8.1
	indoc@1.0.6
	io-lifetimes@0.6.1
	itertools@0.9.0
	itertools@0.10.3
	itoa@1.0.1
	lalrpop@0.19.8
	lalrpop-util@0.19.8
	lazy_static@1.4.0
	libc@0.2.125
	linux-raw-sys@0.0.46
	lock_api@0.4.7
	log@0.4.17
	logos@0.12.0
	logos-derive@0.12.0
	lsp-server@0.5.2
	lsp-types@0.89.2
	maplit@1.0.2
	matches@0.1.9
	memchr@2.5.0
	memoffset@0.6.5
	new_debug_unreachable@1.0.4
	nibble_vec@0.1.0
	nix@0.23.1
	num-bigint@0.4.3
	num-integer@0.1.45
	num-traits@0.2.15
	once_cell@1.10.0
	os_str_bytes@6.0.0
	parking_lot@0.12.0
	parking_lot_core@0.9.3
	paste@1.0.7
	percent-encoding@2.1.0
	petgraph@0.6.0
	phf_shared@0.10.0
	pico-args@0.4.2
	ppv-lite86@0.2.16
	precomputed-hash@0.1.1
	proc-macro-error@1.0.4
	proc-macro-error-attr@1.0.4
	proc-macro2@1.0.38
	quote@1.0.18
	radix_trie@0.2.1
	rand@0.8.5
	rand_chacha@0.3.1
	rand_core@0.6.3
	redox_syscall@0.2.13
	redox_users@0.4.3
	regex@1.5.5
	regex-syntax@0.6.25
	rustc_version@0.4.0
	rustix@0.34.6
	rustversion@1.0.6
	rustyline@9.1.2
	ryu@1.0.9
	same-file@1.0.6
	schemafy@0.5.2
	schemafy_core@0.5.2
	schemafy_lib@0.5.2
	scopeguard@1.1.0
	semver@1.0.9
	serde@1.0.137
	serde_derive@1.0.137
	serde_json@1.0.81
	serde_repr@0.1.8
	siphasher@0.3.10
	smallvec@1.8.0
	smawk@0.3.1
	static_assertions@1.1.0
	str-buf@1.0.5
	string_cache@0.8.4
	strsim@0.8.0
	strsim@0.10.0
	structopt@0.3.26
	structopt-derive@0.4.18
	syn@1.0.93
	term@0.7.0
	textwrap@0.11.0
	textwrap@0.14.2
	thiserror@1.0.31
	thiserror-impl@1.0.31
	tiny-keccak@2.0.2
	tinyvec@1.6.0
	tinyvec_macros@0.1.0
	unicode-bidi@0.3.8
	unicode-linebreak@0.1.2
	unicode-normalization@0.1.19
	unicode-segmentation@1.9.0
	unicode-width@0.1.9
	unicode-xid@0.2.3
	url@2.2.2
	utf8-ranges@1.0.5
	utf8parse@0.2.0
	vec_map@0.8.2
	version_check@0.9.4
	walkdir@2.3.2
	wasi@0.10.2+wasi-snapshot-preview1
	winapi@0.3.9
	winapi-i686-pc-windows-gnu@0.4.0
	winapi-util@0.1.5
	winapi-x86_64-pc-windows-gnu@0.4.0
	windows-sys@0.30.0
	windows-sys@0.36.1
	windows_aarch64_msvc@0.30.0
	windows_aarch64_msvc@0.36.1
	windows_i686_gnu@0.30.0
	windows_i686_gnu@0.36.1
	windows_i686_msvc@0.30.0
	windows_i686_msvc@0.36.1
	windows_x86_64_gnu@0.30.0
	windows_x86_64_gnu@0.36.1
	windows_x86_64_msvc@0.30.0
	windows_x86_64_msvc@0.36.1
	yansi-term@0.1.2
"

inherit cargo

DESCRIPTION="A Rust implementation of the Starlark language"
HOMEPAGE="https://github.com/facebookexperimental/starlark-rust"
SRC_URI="${CARGO_CRATE_URIS}
	https://github.com/facebookexperimental/starlark-rust/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

# Nightly rust-1.53.0 required for https://bugs.gentoo.org/796824
BDEPEND="${RUST_DEPEND}
	>=dev-lang/rust-1.53.0[nightly]"

# RUSTFLAGS support needed: https://bugs.gentoo.org/796887
QA_FLAGS_IGNORED=".*"

src_prepare() {
	sed -e 's:#!\[feature(const_mut_refs)\]:\0\n#![feature(maybe_uninit_extra)]:' \
		-i starlark/src/lib.rs || die
	default
}

src_test() {
	source "${FILESDIR}/test/features.bash" || die
	test-features_main "${PWD}/$(cargo_target_dir)/starlark" || die
}

src_install() {
	dobin "$(cargo_target_dir)/starlark"
	ln "${ED}/usr/bin/starlark"{,-rust} || die
	dodoc -r {docs,{CHANGELOG,README}.md}
}
