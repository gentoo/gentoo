# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
	aho-corasick@1.1.3
	android-tzdata@0.1.1
	android_system_properties@0.1.5
	ansi_term@0.12.1
	anstream@0.6.18
	anstyle-parse@0.2.6
	anstyle-query@1.1.2
	anstyle-wincon@3.0.6
	anstyle@1.0.10
	arrayref@0.3.9
	arrayvec@0.7.6
	autocfg@1.4.0
	bitflags@2.6.0
	blake3@1.5.5
	block-buffer@0.10.4
	bstr@1.11.0
	bumpalo@3.16.0
	byteorder@1.5.0
	camino@1.1.9
	cc@1.2.3
	cfg-if@1.0.0
	cfg_aliases@0.2.1
	chrono@0.4.39
	clap@4.5.23
	clap_builder@4.5.23
	clap_complete@4.5.38
	clap_derive@4.5.18
	clap_lex@0.7.4
	clap_mangen@0.2.24
	colorchoice@1.0.3
	constant_time_eq@0.3.1
	core-foundation-sys@0.8.7
	cpufeatures@0.2.16
	crossbeam-deque@0.8.5
	crossbeam-epoch@0.9.18
	crossbeam-utils@0.8.20
	crypto-common@0.1.6
	ctrlc@3.4.5
	derive-where@1.2.7
	diff@0.1.13
	digest@0.10.7
	dirs-sys@0.4.1
	dirs@5.0.1
	dotenvy@0.15.7
	edit-distance@2.1.3
	either@1.13.0
	errno@0.3.10
	executable-path@1.0.0
	fastrand@2.3.0
	generic-array@0.14.7
	getopts@0.2.21
	getrandom@0.2.15
	heck@0.5.0
	hermit-abi@0.3.9
	home@0.5.9
	iana-time-zone-haiku@0.1.2
	iana-time-zone@0.1.61
	is_terminal_polyfill@1.70.1
	itoa@1.0.14
	js-sys@0.3.76
	lexiclean@0.0.1
	libc@0.2.168
	libredox@0.1.3
	linux-raw-sys@0.4.14
	log@0.4.22
	memchr@2.7.4
	memmap2@0.9.5
	nix@0.29.0
	num-traits@0.2.19
	num_cpus@1.16.0
	once_cell@1.20.2
	option-ext@0.2.0
	percent-encoding@2.3.1
	ppv-lite86@0.2.20
	pretty_assertions@1.4.1
	proc-macro2@1.0.92
	pulldown-cmark-to-cmark@10.0.4
	pulldown-cmark@0.9.6
	quote@1.0.37
	rand@0.8.5
	rand_chacha@0.3.1
	rand_core@0.6.4
	rayon-core@1.12.1
	redox_users@0.4.6
	regex-automata@0.4.9
	regex-syntax@0.8.5
	regex@1.11.1
	roff@0.2.2
	rustix@0.38.42
	rustversion@1.0.18
	ryu@1.0.18
	semver@1.0.23
	serde@1.0.215
	serde_derive@1.0.215
	serde_json@1.0.133
	sha2@0.10.8
	shellexpand@3.1.0
	shlex@1.3.0
	similar@2.6.0
	snafu-derive@0.8.5
	snafu@0.8.5
	strsim@0.11.1
	strum@0.26.3
	strum_macros@0.26.4
	syn@2.0.90
	target@2.1.0
	tempfile@3.14.0
	temptree@0.2.0
	terminal_size@0.4.1
	thiserror-impl@1.0.69
	thiserror@1.0.69
	typed-arena@2.0.2
	typenum@1.17.0
	unicase@2.8.0
	unicode-ident@1.0.14
	unicode-segmentation@1.12.0
	unicode-width@0.1.14
	unicode-width@0.2.0
	utf8parse@0.2.2
	uuid@1.11.0
	version_check@0.9.5
	wasi@0.11.0+wasi-snapshot-preview1
	wasm-bindgen-backend@0.2.99
	wasm-bindgen-macro-support@0.2.99
	wasm-bindgen-macro@0.2.99
	wasm-bindgen-shared@0.2.99
	wasm-bindgen@0.2.99
	which@7.0.0
	winapi-i686-pc-windows-gnu@0.4.0
	winapi-x86_64-pc-windows-gnu@0.4.0
	winapi@0.3.9
	windows-core@0.52.0
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
	winsafe@0.0.19
	yansi@1.0.1
	zerocopy-derive@0.7.35
	zerocopy@0.7.35
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
LICENSE+=" Apache-2.0 BSD-2 CC0-1.0 MIT MPL-2.0 Unicode-3.0"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

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

	mkdir completions || die

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
