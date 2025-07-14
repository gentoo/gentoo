# Copyright 2024-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
	aho-corasick@1.1.3
	android-tzdata@0.1.1
	android_system_properties@0.1.5
	ansi_term@0.12.1
	anstream@0.6.19
	anstyle-parse@0.2.7
	anstyle-query@1.1.3
	anstyle-wincon@3.0.9
	anstyle@1.0.11
	arrayref@0.3.9
	arrayvec@0.7.6
	autocfg@1.5.0
	bitflags@2.9.1
	blake3@1.8.2
	block-buffer@0.10.4
	bstr@1.12.0
	bumpalo@3.19.0
	camino@1.1.10
	cc@1.2.30
	cfg-if@1.0.1
	cfg_aliases@0.2.1
	chrono@0.4.41
	clap@4.5.41
	clap_builder@4.5.41
	clap_complete@4.5.48
	clap_derive@4.5.41
	clap_lex@0.7.5
	clap_mangen@0.2.28
	colorchoice@1.0.4
	constant_time_eq@0.3.1
	core-foundation-sys@0.8.7
	cpufeatures@0.2.17
	crossbeam-deque@0.8.6
	crossbeam-epoch@0.9.18
	crossbeam-utils@0.8.21
	crypto-common@0.1.6
	ctrlc@3.4.7
	derive-where@1.5.0
	diff@0.1.13
	digest@0.10.7
	dirs-sys@0.5.0
	dirs@6.0.0
	dotenvy@0.15.7
	edit-distance@2.1.3
	env_home@0.1.0
	errno@0.3.13
	executable-path@1.0.0
	fastrand@2.3.0
	generic-array@0.14.7
	getopts@0.2.23
	getrandom@0.2.16
	getrandom@0.3.3
	heck@0.5.0
	hermit-abi@0.5.2
	iana-time-zone-haiku@0.1.2
	iana-time-zone@0.1.63
	is_executable@1.0.4
	is_terminal_polyfill@1.70.1
	itoa@1.0.15
	js-sys@0.3.77
	lexiclean@0.0.1
	libc@0.2.174
	libredox@0.1.6
	linux-raw-sys@0.9.4
	log@0.4.27
	memchr@2.7.5
	memmap2@0.9.7
	nix@0.30.1
	num-traits@0.2.19
	num_cpus@1.17.0
	once_cell@1.21.3
	once_cell_polyfill@1.70.1
	option-ext@0.2.0
	percent-encoding@2.3.1
	ppv-lite86@0.2.21
	pretty_assertions@1.4.1
	proc-macro2@1.0.95
	pulldown-cmark-to-cmark@10.0.4
	pulldown-cmark@0.9.6
	quote@1.0.40
	r-efi@5.3.0
	rand@0.9.2
	rand_chacha@0.9.0
	rand_core@0.9.3
	rayon-core@1.12.1
	redox_users@0.5.0
	regex-automata@0.4.9
	regex-syntax@0.8.5
	regex@1.11.1
	roff@0.2.2
	rustix@1.0.8
	rustversion@1.0.21
	ryu@1.0.20
	semver@1.0.26
	serde@1.0.219
	serde_derive@1.0.219
	serde_json@1.0.141
	sha2@0.10.9
	shellexpand@3.1.1
	shlex@1.3.0
	similar@2.7.0
	snafu-derive@0.8.6
	snafu@0.8.6
	strsim@0.11.1
	strum@0.27.2
	strum_macros@0.27.2
	syn@2.0.104
	target@2.1.0
	tempfile@3.20.0
	temptree@0.2.0
	terminal_size@0.4.2
	thiserror-impl@2.0.12
	thiserror@2.0.12
	typed-arena@2.0.2
	typenum@1.18.0
	unicase@2.8.1
	unicode-ident@1.0.18
	unicode-segmentation@1.12.0
	unicode-width@0.2.1
	utf8parse@0.2.2
	uuid@1.17.0
	version_check@0.9.5
	wasi@0.11.1+wasi-snapshot-preview1
	wasi@0.14.2+wasi-0.2.4
	wasm-bindgen-backend@0.2.100
	wasm-bindgen-macro-support@0.2.100
	wasm-bindgen-macro@0.2.100
	wasm-bindgen-shared@0.2.100
	wasm-bindgen@0.2.100
	which@8.0.0
	winapi-i686-pc-windows-gnu@0.4.0
	winapi-x86_64-pc-windows-gnu@0.4.0
	winapi@0.3.9
	windows-core@0.61.2
	windows-implement@0.60.0
	windows-interface@0.59.1
	windows-link@0.1.3
	windows-result@0.3.4
	windows-strings@0.4.2
	windows-sys@0.59.0
	windows-sys@0.60.2
	windows-targets@0.52.6
	windows-targets@0.53.2
	windows_aarch64_gnullvm@0.52.6
	windows_aarch64_gnullvm@0.53.0
	windows_aarch64_msvc@0.52.6
	windows_aarch64_msvc@0.53.0
	windows_i686_gnu@0.52.6
	windows_i686_gnu@0.53.0
	windows_i686_gnullvm@0.52.6
	windows_i686_gnullvm@0.53.0
	windows_i686_msvc@0.52.6
	windows_i686_msvc@0.53.0
	windows_x86_64_gnu@0.52.6
	windows_x86_64_gnu@0.53.0
	windows_x86_64_gnullvm@0.52.6
	windows_x86_64_gnullvm@0.53.0
	windows_x86_64_msvc@0.52.6
	windows_x86_64_msvc@0.53.0
	winsafe@0.0.19
	wit-bindgen-rt@0.39.0
	yansi@1.0.1
	zerocopy-derive@0.8.26
	zerocopy@0.8.26
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
