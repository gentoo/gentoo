# Copyright 2024-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

RUST_MIN_VER="1.87.0"

CRATES="
	aho-corasick@1.1.4
	android_system_properties@0.1.5
	ansi_term@0.12.1
	anstream@1.0.0
	anstyle-parse@1.0.0
	anstyle-query@1.1.5
	anstyle-wincon@3.0.11
	anstyle@1.0.14
	anyhow@1.0.102
	arrayref@0.3.9
	arrayvec@0.7.6
	autocfg@1.5.0
	bitflags@2.11.0
	blake3@1.8.4
	block-buffer@0.10.4
	block2@0.6.2
	bstr@1.12.1
	bumpalo@3.20.2
	bytecount@0.6.9
	camino@1.2.2
	cc@1.2.59
	cfg-if@1.0.4
	cfg_aliases@0.2.1
	chacha20@0.10.0
	chrono@0.4.44
	clap@4.6.0
	clap_builder@4.6.0
	clap_complete@4.6.0
	clap_derive@4.6.0
	clap_lex@1.1.0
	clap_mangen@0.3.0
	colorchoice@1.0.5
	constant_time_eq@0.4.2
	core-foundation-sys@0.8.7
	cpufeatures@0.2.17
	cpufeatures@0.3.0
	crossbeam-deque@0.8.6
	crossbeam-epoch@0.9.18
	crossbeam-utils@0.8.21
	crypto-common@0.1.7
	ctrlc@3.5.2
	diff@0.1.13
	digest@0.10.7
	dirs-sys@0.5.0
	dirs@6.0.0
	dispatch2@0.3.1
	dotenvy@0.15.7
	edit-distance@2.2.2
	equivalent@1.0.2
	errno@0.3.14
	fastrand@2.4.0
	find-msvc-tools@0.1.9
	fnv@1.0.7
	foldhash@0.1.5
	generic-array@0.14.7
	getopts@0.2.24
	getrandom@0.2.17
	getrandom@0.4.2
	hashbrown@0.15.5
	hashbrown@0.16.1
	heck@0.5.0
	hermit-abi@0.5.2
	iana-time-zone-haiku@0.1.2
	iana-time-zone@0.1.65
	id-arena@2.3.0
	indexmap@2.13.1
	is_executable@1.0.5
	is_terminal_polyfill@1.70.2
	itoa@1.0.18
	js-sys@0.3.94
	leb128fmt@0.1.0
	lexiclean@0.0.1
	libc@0.2.184
	libredox@0.1.15
	linux-raw-sys@0.12.1
	log@0.4.29
	memchr@2.8.0
	memmap2@0.9.10
	nix@0.31.2
	num-traits@0.2.19
	num_cpus@1.17.0
	objc2-encode@4.1.0
	objc2@0.6.4
	once_cell@1.21.4
	once_cell_polyfill@1.70.2
	option-ext@0.2.0
	papergrid@0.14.0
	percent-encoding@2.3.2
	pretty_assertions@1.4.1
	prettyplease@0.2.37
	proc-macro-error-attr2@2.0.0
	proc-macro-error2@2.0.1
	proc-macro2@1.0.106
	pulldown-cmark-to-cmark@10.0.4
	pulldown-cmark@0.9.6
	quote@1.0.45
	r-efi@6.0.0
	rand@0.10.0
	rand_core@0.10.0
	rayon-core@1.13.0
	redox_users@0.5.2
	regex-automata@0.4.14
	regex-syntax@0.8.10
	regex@1.12.3
	roff@1.1.1
	rustix@1.1.4
	rustversion@1.0.22
	ryu@1.0.23
	semver@1.0.28
	serde@1.0.228
	serde_core@1.0.228
	serde_derive@1.0.228
	serde_json@1.0.149
	serde_yaml@0.9.34+deprecated
	sha2@0.10.9
	shellexpand@3.1.2
	shlex@1.3.0
	similar@3.0.0
	snafu-derive@0.9.0
	snafu@0.9.0
	strsim@0.11.1
	strum@0.28.0
	strum_macros@0.28.0
	syn@2.0.117
	tabled@0.18.0
	tabled_derive@0.10.0
	target@2.1.0
	tempfile@3.27.0
	temptree@0.2.0
	terminal_size@0.4.4
	thiserror-impl@2.0.18
	thiserror@2.0.18
	typed-arena@2.0.2
	typenum@1.19.0
	unicase@2.9.0
	unicode-ident@1.0.24
	unicode-segmentation@1.13.2
	unicode-width@0.2.2
	unicode-xid@0.2.6
	unsafe-libyaml@0.2.11
	utf8parse@0.2.2
	uuid@1.23.0
	version_check@0.9.5
	wasi@0.11.1+wasi-snapshot-preview1
	wasip2@1.0.1+wasi-0.2.4
	wasip3@0.4.0+wasi-0.3.0-rc-2026-01-06
	wasm-bindgen-macro-support@0.2.117
	wasm-bindgen-macro@0.2.117
	wasm-bindgen-shared@0.2.117
	wasm-bindgen@0.2.117
	wasm-encoder@0.244.0
	wasm-metadata@0.244.0
	wasmparser@0.244.0
	which@8.0.2
	winapi-i686-pc-windows-gnu@0.4.0
	winapi-x86_64-pc-windows-gnu@0.4.0
	winapi@0.3.9
	windows-core@0.62.2
	windows-implement@0.60.2
	windows-interface@0.59.3
	windows-link@0.2.1
	windows-result@0.4.1
	windows-strings@0.5.1
	windows-sys@0.60.2
	windows-sys@0.61.2
	windows-targets@0.53.5
	windows_aarch64_gnullvm@0.53.1
	windows_aarch64_msvc@0.53.1
	windows_i686_gnu@0.53.1
	windows_i686_gnullvm@0.53.1
	windows_i686_msvc@0.53.1
	windows_x86_64_gnu@0.53.1
	windows_x86_64_gnullvm@0.53.1
	windows_x86_64_msvc@0.53.1
	wit-bindgen-core@0.51.0
	wit-bindgen-rust-macro@0.51.0
	wit-bindgen-rust@0.51.0
	wit-bindgen@0.46.0
	wit-bindgen@0.51.0
	wit-component@0.244.0
	wit-parser@0.244.0
	yansi@1.0.1
	zmij@1.0.21
	${PN}@${PV}
"

inherit cargo shell-completion toolchain-funcs

DESCRIPTION="Just a command runner (with syntax inspired by 'make')"
HOMEPAGE="
	https://just.systems/
	https://crates.io/crates/just
	https://github.com/casey/just
"
SRC_URI="${CARGO_CRATE_URIS}"

LICENSE="CC0-1.0"
# Dependent crate licenses
LICENSE+=" Apache-2.0 BSD-2 CC0-1.0 MIT MPL-2.0 Unicode-3.0 ZLIB"
SLOT="0"
KEYWORDS="amd64 ~arm64"

QA_FLAGS_IGNORED="usr/bin/${PN}"

src_test() {
	default
}

src_prepare() {
	default
	tc-export CC
}

src_install() {
	local DOCS=( README.md )

	cargo_src_install

	mkdir man || die
	$(cargo_target_dir)/just --man > man/just.1 || die

	doman man/*

	einstalldocs

	# bash-completion
	$(cargo_target_dir)/just --completions bash > completions/just.bash || die
	newbashcomp "completions/${PN}.bash" "${PN}"

	# zsh-completion
	$(cargo_target_dir)/just --completions zsh > completions/just.zsh || die
	newzshcomp "completions/${PN}.zsh" "_${PN}"

	# fish-completion
	$(cargo_target_dir)/just --completions fish > completions/just.fish || die
	dofishcomp "completions/${PN}.fish"
}
