# Copyright 2024-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

RUST_MIN_VER="1.89.0"

CRATES="
	aho-corasick@1.1.5
	android_system_properties@0.1.6
	anstream@1.0.0
	anstyle-parse@1.0.0
	anstyle-query@1.1.5
	anstyle-wincon@3.0.11
	anstyle@1.0.14
	arrayvec@0.7.8
	autocfg@1.5.1
	bitflags@2.13.2
	blake3@1.8.7
	block-buffer@0.12.1
	block2@0.6.2
	bstr@1.13.1
	bumpalo@3.20.3
	bytecount@0.6.9
	camino@1.2.6
	cc@1.8.0
	cfg-if@1.0.5
	cfg_aliases@0.2.2
	chacha20@0.10.2
	chrono@0.4.45
	clap@4.6.7
	clap_builder@4.6.7
	clap_complete@4.6.11
	clap_derive@4.6.7
	clap_lex@1.1.1
	clap_mangen@0.3.3
	colorchoice@1.0.5
	const-oid@0.10.2
	constant_time_eq@0.4.2
	core-foundation-sys@0.8.7
	cpufeatures@0.3.1
	crossbeam-deque@0.8.8
	crossbeam-epoch@0.9.21
	crossbeam-utils@0.8.23
	crypto-common@0.2.2
	ctrlc@3.5.2
	diff@0.1.13
	digest-io@0.1.0
	digest@0.11.3
	dirs-sys@0.5.0
	dirs@6.0.0
	dirs@7.0.0
	dispatch2@0.3.1
	dotenvy@0.15.7
	equivalent@1.0.3
	errno@0.3.14
	fastrand@2.5.0
	find-msvc-tools@0.1.14
	fnv@1.0.7
	futures-core@0.3.34
	futures-task@0.3.34
	futures-util@0.3.34
	getopts@0.2.24
	getrandom@0.4.3
	hashbrown@0.17.1
	heck@0.5.0
	hermit-abi@0.5.3
	hex@0.4.3
	hybrid-array@0.4.15
	iana-time-zone-haiku@0.1.2
	iana-time-zone@0.1.65
	indexmap@2.14.2
	is_executable@1.0.6
	is_terminal_polyfill@1.70.2
	itoa@1.0.18
	js-sys@0.3.106
	libc@0.2.190
	libredox@0.1.25
	linux-raw-sys@0.12.1
	log@0.4.34
	memchr@2.8.3
	memmap2@0.9.11
	nix@0.31.3
	nu-ansi-term@0.50.3
	num-traits@0.2.19
	num_cpus@1.17.0
	objc2-encode@4.1.0
	objc2@0.6.5
	once_cell@1.21.4
	once_cell_polyfill@1.70.2
	option-ext@0.2.0
	papergrid@0.18.0
	percent-encoding@2.3.2
	pin-project-lite@0.2.17
	pretty_assertions@1.4.1
	proc-macro2@1.0.107
	pulldown-cmark-to-cmark@10.0.4
	pulldown-cmark@0.13.4
	pulldown-cmark@0.9.6
	quote@1.0.47
	r-efi@6.0.0
	rand@0.10.3
	rand_core@0.10.1
	rayon-core@1.13.0
	redox_users@0.5.3
	regex-automata@0.4.18
	regex-syntax@0.8.11
	regex@1.13.1
	roff@1.1.1
	rustix@1.1.5
	rustversion@1.0.23
	ryu@1.0.23
	semver@1.0.28
	serde@1.0.229
	serde_core@1.0.229
	serde_derive@1.0.229
	serde_json@1.0.154
	serde_yaml@0.9.34+deprecated
	sha2@0.11.1
	shellexpand@3.1.2
	shlex@2.0.1
	similar@3.2.0
	slab@0.4.12
	snafu-derive@0.9.2
	snafu@0.9.2
	strsim@0.11.1
	strum@0.28.0
	strum_macros@0.28.0
	syn@2.0.119
	syn@3.0.9
	tabled@0.22.0
	tabled_derive@0.12.0
	tempfile@3.27.0
	terminal_size@0.4.4
	testing_table@0.3.0
	thiserror-impl@2.0.21
	thiserror@2.0.21
	typed-arena@2.0.2
	typenum@1.20.1
	unicase@2.10.0
	unicode-ident@1.0.27
	unicode-segmentation@1.13.3
	unicode-width@0.2.2
	unsafe-libyaml@0.2.11
	utf8parse@0.2.2
	uuid@1.28.0
	wasm-bindgen-macro-support@0.2.129
	wasm-bindgen-macro@0.2.129
	wasm-bindgen-shared@0.2.129
	wasm-bindgen@0.2.129
	which@8.0.6
	windows-core@0.62.2
	windows-implement@0.60.2
	windows-interface@0.59.3
	windows-link@0.2.1
	windows-result@0.4.1
	windows-strings@0.5.1
	windows-sys@0.61.2
	yansi@1.0.1
	zmij@1.0.23
	${PN}@${PV}
"

inherit cargo shell-completion sysroot

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
KEYWORDS="~amd64 ~arm64"

QA_FLAGS_IGNORED="usr/bin/${PN}"

src_compile() {
	cargo_src_compile

	sysroot_try_run_prefixed "$(cargo_target_dir)"/${PN} --man > ${PN}.1 || die
	sysroot_try_run_prefixed "$(cargo_target_dir)"/${PN} --completions bash > completions/${PN}.bash || die
	sysroot_try_run_prefixed "$(cargo_target_dir)"/${PN} --completions zsh > completions/${PN}.zsh || die
	sysroot_try_run_prefixed "$(cargo_target_dir)"/${PN} --completions fish > completions/${PN}.fish || die
}

src_test() {
	:
}

src_install() {
	cargo_src_install

	[[ -s ${PN}.1 ]] && doman ${PN}.1
	[[ -s completions/${PN}.bash ]] && newbashcomp completions/${PN}.bash ${PN}
	[[ -s completions/${PN}.zsh ]] && newzshcomp completions/${PN}.zsh _${PN}
	[[ -s completions/${PN}.fish ]] && dofishcomp completions/${PN}.fish

	local DOCS=( README.md )
	einstalldocs
}
