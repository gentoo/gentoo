# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN=tree-sitter
MY_P=tree-sitter-${PV}
CRATES="
	aho-corasick-0.7.15
	ansi_term-0.11.0
	ansi_term-0.12.1
	anyhow-1.0.40
	arrayref-0.3.6
	arrayvec-0.5.2
	ascii-1.0.0
	atty-0.2.14
	autocfg-1.0.1
	base64-0.13.0
	bitflags-1.2.1
	blake2b_simd-0.5.11
	bumpalo-3.6.1
	cc-1.0.67
	cfg-if-1.0.0
	chrono-0.4.19
	chunked_transfer-1.4.0
	clap-2.33.3
	constant_time_eq-0.1.5
	crossbeam-utils-0.8.3
	ctor-0.1.20
	diff-0.1.12
	difference-2.0.0
	dirs-3.0.1
	dirs-sys-0.3.5
	either-1.6.1
	form_urlencoded-1.0.1
	getrandom-0.1.16
	getrandom-0.2.2
	glob-0.3.0
	hashbrown-0.9.1
	hermit-abi-0.1.18
	html-escape-0.2.6
	idna-0.2.2
	indexmap-1.6.1
	itoa-0.4.7
	js-sys-0.3.48
	lazy_static-1.4.0
	libc-0.2.86
	libloading-0.7.0
	log-0.4.14
	matches-0.1.8
	memchr-2.3.4
	num-integer-0.1.44
	num-traits-0.2.14
	once_cell-1.7.0
	output_vt100-0.1.2
	percent-encoding-2.1.0
	ppv-lite86-0.2.10
	pretty_assertions-0.7.2
	proc-macro2-1.0.24
	quote-1.0.9
	rand-0.8.3
	rand_chacha-0.3.0
	rand_core-0.6.2
	rand_hc-0.3.0
	redox_syscall-0.1.57
	redox_syscall-0.2.5
	redox_users-0.3.5
	regex-1.4.3
	regex-syntax-0.6.22
	remove_dir_all-0.5.3
	rust-argon2-0.8.3
	rustc-hash-1.1.0
	ryu-1.0.5
	same-file-1.0.6
	semver-1.0.5
	serde-1.0.130
	serde_derive-1.0.130
	serde_json-1.0.63
	smallbitvec-2.5.1
	strsim-0.8.0
	syn-1.0.67
	tempfile-3.2.0
	textwrap-0.11.0
	thiserror-1.0.25
	thiserror-impl-1.0.25
	thread_local-1.1.3
	time-0.1.43
	tiny_http-0.8.0
	tinyvec-1.1.1
	tinyvec_macros-0.1.0
	toml-0.5.8
	unicode-bidi-0.3.4
	unicode-normalization-0.1.17
	unicode-width-0.1.8
	unicode-xid-0.2.1
	url-2.2.1
	utf8-width-0.1.4
	vec_map-0.8.2
	walkdir-2.3.1
	wasi-0.9.0+wasi-snapshot-preview1
	wasi-0.10.2+wasi-snapshot-preview1
	wasm-bindgen-0.2.71
	wasm-bindgen-backend-0.2.71
	wasm-bindgen-macro-0.2.71
	wasm-bindgen-macro-support-0.2.71
	wasm-bindgen-shared-0.2.71
	web-sys-0.3.48
	webbrowser-0.5.5
	which-4.1.0
	widestring-0.4.3
	winapi-0.3.9
	winapi-i686-pc-windows-gnu-0.4.0
	winapi-util-0.1.5
	winapi-x86_64-pc-windows-gnu-0.4.0
"

inherit cargo

DESCRIPTION="Command-line tool for creating and testing tree-sitter grammars"
HOMEPAGE="https://github.com/tree-sitter/tree-sitter"
SRC_URI="https://github.com/${MY_PN}/${MY_PN}/archive/refs/tags/v${PV}.tar.gz -> ${MY_P}.tar.gz
$(cargo_crate_uris)"
S="${WORKDIR}"/${MY_P}/cli

LICENSE="Apache-2.0 BSD-2 CC0-1.0 ISC MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~riscv ~sparc"

# Test seems to require files (grammar definitions) that we don't have.
RESTRICT="test"

BDEPEND="~dev-libs/tree-sitter-${PV}"
RDEPEND="${BDEPEND}"

QA_FLAGS_IGNORED="usr/bin/${MY_PN}"

src_prepare() {
	default

	# Existing build.rs file invokes cc to rebuild the tree-sitter library.
	# Link with the system one instead.
	cp "${FILESDIR}"/tree-sitter-cli-0.20.2-r1-build.rs \
	   "${WORKDIR}"/${MY_P}/lib/binding_rust/build.rs || die
}
