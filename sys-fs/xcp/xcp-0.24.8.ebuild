# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

RUST_MIN_VER="1.88.0"
CRATES="
	aho-corasick@1.1.4
	anstream@1.0.0
	anstyle-parse@1.0.0
	anstyle-query@1.1.5
	anstyle-wincon@3.0.11
	anstyle@1.0.14
	anyhow@1.0.102
	autocfg@1.5.0
	bitflags@2.11.1
	blocking-threadpool@1.0.3
	bstr@1.12.1
	bumpalo@3.20.2
	cfg-if@1.0.4
	chacha20@0.10.0
	clap@4.6.1
	clap_builder@4.6.0
	clap_derive@4.6.1
	clap_lex@1.1.0
	colorchoice@1.0.5
	console@0.16.3
	cpufeatures@0.3.0
	crossbeam-channel@0.5.15
	crossbeam-deque@0.8.6
	crossbeam-epoch@0.9.18
	crossbeam-utils@0.8.21
	deranged@0.5.8
	encode_unicode@1.0.0
	equivalent@1.0.2
	errno@0.3.14
	exacl@0.12.0
	fastrand@2.4.1
	foldhash@0.1.5
	fslock@0.2.1
	futures-core@0.3.32
	futures-task@0.3.32
	futures-util@0.3.32
	getrandom@0.4.2
	glob@0.3.3
	globset@0.4.18
	hashbrown@0.15.5
	hashbrown@0.17.0
	heck@0.5.0
	hermit-abi@0.5.2
	id-arena@2.3.0
	ignore@0.4.25
	indexmap@2.14.0
	indicatif@0.18.4
	is_terminal_polyfill@1.70.2
	itoa@1.0.18
	js-sys@0.3.97
	lazy_static@0.2.11
	leb128fmt@0.1.0
	libc@0.2.186
	libm@0.2.16
	linux-raw-sys@0.12.1
	log@0.4.29
	memchr@2.8.0
	num-conv@0.2.1
	num-traits@0.2.19
	num_cpus@1.17.0
	num_threads@0.1.7
	once_cell@1.21.4
	once_cell_polyfill@1.70.2
	pin-project-lite@0.2.17
	portable-atomic@1.13.1
	powerfmt@0.2.0
	prettyplease@0.2.37
	proc-macro2@1.0.106
	quote@1.0.45
	r-efi@6.0.0
	rand@0.10.1
	rand_core@0.10.1
	rand_distr@0.6.0
	rand_xorshift@0.5.0
	regex-automata@0.4.14
	regex-syntax@0.8.10
	regex@1.12.3
	rustix@1.1.4
	rustversion@1.0.22
	same-file@1.0.6
	scopeguard@1.2.0
	semver@1.0.28
	serde@1.0.228
	serde_core@1.0.228
	serde_derive@1.0.228
	serde_json@1.0.149
	simplelog@0.12.2
	slab@0.4.12
	strsim@0.11.1
	syn@2.0.117
	tempfile@3.27.0
	termcolor@1.4.1
	terminal_size@0.4.4
	test-case-core@3.3.1
	test-case-macros@3.3.1
	test-case@3.3.1
	thiserror-impl@2.0.18
	thiserror@2.0.18
	time-core@0.1.8
	time-macros@0.2.27
	time@0.3.47
	unbytify@0.2.0
	unicode-ident@1.0.24
	unicode-width@0.2.2
	unicode-xid@0.2.6
	unit-prefix@0.5.2
	utf8parse@0.2.2
	uuid@1.23.1
	walkdir@2.5.0
	wasip2@1.0.3+wasi-0.2.9
	wasip3@0.4.0+wasi-0.3.0-rc-2026-01-06
	wasm-bindgen-macro-support@0.2.120
	wasm-bindgen-macro@0.2.120
	wasm-bindgen-shared@0.2.120
	wasm-bindgen@0.2.120
	wasm-encoder@0.244.0
	wasm-metadata@0.244.0
	wasmparser@0.244.0
	web-time@1.1.0
	winapi-i686-pc-windows-gnu@0.4.0
	winapi-util@0.1.11
	winapi-x86_64-pc-windows-gnu@0.4.0
	winapi@0.3.9
	windows-link@0.2.1
	windows-sys@0.61.2
	wit-bindgen-core@0.51.0
	wit-bindgen-rust-macro@0.51.0
	wit-bindgen-rust@0.51.0
	wit-bindgen@0.51.0
	wit-bindgen@0.57.1
	wit-component@0.244.0
	wit-parser@0.244.0
	xattr@1.6.1
	zmij@1.0.21
"

inherit cargo shell-completion

DESCRIPTION="A 'cp' alternative with user-friendly feedback and performance optimisations"
HOMEPAGE="https://github.com/tarka/xcp"
SRC_URI="
	https://github.com/tarka/xcp/archive/refs/tags/xcp-v${PV}.tar.gz
		-> xcp-${PV}.tar.gz
	${CARGO_CRATE_URIS}
"

S="${WORKDIR}/xcp-xcp-v${PV}"

LICENSE="GPL-3"
# Dependent crate licenses
LICENSE+=" Apache-2.0 MIT Unicode-3.0 ZLIB"
SLOT="0"
KEYWORDS="~amd64"

src_install() {
	cargo_src_install

	dofishcomp completions/xcp.fish
	dozshcomp completions/xcp.zsh
	newbashcomp completions/xcp.bash xcp

	dodoc CHANGELOG.md README.md
}

src_test() {
	# reflink tests are unreliable on certain filesystems
	local CARGO_SKIP_TESTS=(
		test::file_copy_reflink_always::test_with_parallel_file_driver
		test::file_copy_reflink_always::test_with_parallel_block_driver
	)
	cargo_src_test
}
