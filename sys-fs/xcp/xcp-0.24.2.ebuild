# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

RUST_MIN_VER="1.88.0"
CRATES="
	aho-corasick@1.1.3
	anstream@0.6.20
	anstyle-parse@0.2.7
	anstyle-query@1.1.4
	anstyle-wincon@3.0.10
	anstyle@1.0.11
	anyhow@1.0.99
	autocfg@1.4.0
	bitflags@2.9.2
	blocking-threadpool@1.0.1
	bstr@1.10.0
	bumpalo@3.19.0
	cfg-if@1.0.3
	clap@4.5.46
	clap_builder@4.5.46
	clap_derive@4.5.45
	clap_lex@0.7.5
	colorchoice@1.0.4
	console@0.16.0
	crossbeam-channel@0.5.15
	crossbeam-deque@0.8.5
	crossbeam-epoch@0.9.18
	crossbeam-utils@0.8.21
	deranged@0.3.11
	encode_unicode@1.0.0
	errno@0.3.13
	exacl@0.12.0
	fastrand@2.3.0
	fslock@0.2.1
	getrandom@0.3.3
	glob@0.3.3
	globset@0.4.15
	heck@0.5.0
	hermit-abi@0.5.2
	ignore@0.4.23
	indicatif@0.18.0
	is_terminal_polyfill@1.70.1
	itoa@1.0.11
	js-sys@0.3.77
	lazy_static@0.2.11
	libc@0.2.175
	libm@0.2.11
	linux-raw-sys@0.10.0
	linux-raw-sys@0.9.4
	log@0.4.27
	memchr@2.7.5
	num-conv@0.1.0
	num-traits@0.2.19
	num_cpus@1.17.0
	num_threads@0.1.7
	once_cell@1.21.3
	once_cell_polyfill@1.70.1
	portable-atomic@1.11.1
	powerfmt@0.2.0
	ppv-lite86@0.2.21
	proc-macro2@1.0.101
	quote@1.0.40
	r-efi@5.3.0
	rand@0.9.2
	rand_chacha@0.9.0
	rand_core@0.9.3
	rand_distr@0.5.1
	rand_xorshift@0.4.0
	regex-automata@0.4.10
	regex-syntax@0.8.6
	regex@1.11.2
	rustix@1.0.8
	rustversion@1.0.21
	same-file@1.0.6
	scopeguard@1.2.0
	serde@1.0.210
	serde_derive@1.0.210
	simplelog@0.12.2
	strsim@0.11.1
	syn@2.0.106
	tempfile@3.21.0
	termcolor@1.4.1
	terminal_size@0.4.3
	test-case-core@3.3.1
	test-case-macros@3.3.1
	test-case@3.3.1
	thiserror-impl@2.0.16
	thiserror@2.0.16
	time-core@0.1.2
	time-macros@0.2.18
	time@0.3.36
	unbytify@0.2.0
	unicode-ident@1.0.18
	unicode-width@0.2.1
	unit-prefix@0.5.1
	utf8parse@0.2.2
	uuid@1.18.0
	walkdir@2.5.0
	wasi@0.14.2+wasi-0.2.4
	wasm-bindgen-backend@0.2.100
	wasm-bindgen-macro-support@0.2.100
	wasm-bindgen-macro@0.2.100
	wasm-bindgen-shared@0.2.100
	wasm-bindgen@0.2.100
	web-time@1.1.0
	winapi-i686-pc-windows-gnu@0.4.0
	winapi-util@0.1.8
	winapi-x86_64-pc-windows-gnu@0.4.0
	winapi@0.3.9
	windows-link@0.1.3
	windows-sys@0.52.0
	windows-sys@0.60.2
	windows-targets@0.52.6
	windows-targets@0.53.3
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
	wit-bindgen-rt@0.39.0
	xattr@1.5.1
	zerocopy-derive@0.8.26
	zerocopy@0.8.26
"

inherit cargo shell-completion

DESCRIPTION="A 'cp' alternative with user-friendly feedback and performance optimisations"
HOMEPAGE="https://github.com/tarka/xcp"
SRC_URI="
	https://github.com/tarka/xcp/archive/refs/tags/v${PV}.tar.gz
		-> xcp-${PV}.tar.gz
	${CARGO_CRATE_URIS}
"

LICENSE="GPL-3"
# Dependent crate licenses
LICENSE+=" Apache-2.0 MIT Unicode-3.0"
SLOT="0"
KEYWORDS="~amd64"

src_install() {
	cargo_src_install

	dofishcomp completions/xcp.fish
	dozshcomp completions/xcp.zsh
	dobashcomp completions/xcp.bash
}
