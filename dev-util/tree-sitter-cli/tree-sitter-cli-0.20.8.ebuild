# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN=tree-sitter
MY_P=tree-sitter-${PV}
CRATES="
	aho-corasick-0.7.20
	ansi_term-0.12.1
	anyhow-1.0.70
	ascii-1.1.0
	atty-0.2.14
	autocfg-1.1.0
	bitflags-1.3.2
	bumpalo-3.12.0
	bytes-1.4.0
	cc-1.0.79
	cesu8-1.1.0
	cfg-if-1.0.0
	chunked_transfer-1.4.1
	clap-2.34.0
	combine-4.6.6
	core-foundation-0.9.3
	core-foundation-sys-0.8.4
	ctor-0.1.26
	diff-0.1.13
	difference-2.0.0
	dirs-3.0.2
	dirs-4.0.0
	dirs-sys-0.3.7
	either-1.8.1
	errno-0.3.0
	errno-dragonfly-0.1.2
	fastrand-1.9.0
	form_urlencoded-1.1.0
	getrandom-0.2.8
	glob-0.3.1
	hashbrown-0.12.3
	hermit-abi-0.1.19
	hermit-abi-0.3.1
	html-escape-0.2.13
	httpdate-1.0.2
	idna-0.3.0
	indexmap-1.9.3
	instant-0.1.12
	io-lifetimes-1.0.9
	itoa-1.0.6
	jni-0.21.1
	jni-sys-0.3.0
	js-sys-0.3.61
	lazy_static-1.4.0
	libc-0.2.141
	libloading-0.7.4
	linux-raw-sys-0.3.1
	log-0.4.17
	malloc_buf-0.0.6
	memchr-2.5.0
	ndk-context-0.1.1
	objc-0.2.7
	once_cell-1.17.1
	output_vt100-0.1.3
	percent-encoding-2.2.0
	ppv-lite86-0.2.17
	pretty_assertions-0.7.2
	proc-macro2-1.0.56
	quote-1.0.26
	rand-0.8.5
	rand_chacha-0.3.1
	rand_core-0.6.4
	raw-window-handle-0.5.2
	redox_syscall-0.2.16
	redox_syscall-0.3.5
	redox_users-0.4.3
	regex-1.7.3
	regex-syntax-0.6.29
	rustc-hash-1.1.0
	rustix-0.37.7
	ryu-1.0.13
	same-file-1.0.6
	semver-1.0.17
	serde-1.0.159
	serde_derive-1.0.159
	serde_json-1.0.95
	smallbitvec-2.5.1
	strsim-0.8.0
	syn-1.0.109
	syn-2.0.13
	tempfile-3.5.0
	textwrap-0.11.0
	thiserror-1.0.40
	thiserror-impl-1.0.40
	tiny_http-0.12.0
	tinyvec-1.6.0
	tinyvec_macros-0.1.1
	toml-0.5.11
	unicode-bidi-0.3.13
	unicode-ident-1.0.8
	unicode-normalization-0.1.22
	unicode-width-0.1.10
	unindent-0.2.1
	url-2.3.1
	utf8-width-0.1.6
	vec_map-0.8.2
	walkdir-2.3.3
	wasi-0.11.0+wasi-snapshot-preview1
	wasm-bindgen-0.2.84
	wasm-bindgen-backend-0.2.84
	wasm-bindgen-macro-0.2.84
	wasm-bindgen-macro-support-0.2.84
	wasm-bindgen-shared-0.2.84
	web-sys-0.3.61
	webbrowser-0.8.8
	which-4.4.0
	winapi-0.3.9
	winapi-i686-pc-windows-gnu-0.4.0
	winapi-util-0.1.5
	winapi-x86_64-pc-windows-gnu-0.4.0
	windows-sys-0.45.0
	windows-targets-0.42.2
	windows_aarch64_gnullvm-0.42.2
	windows_aarch64_msvc-0.42.2
	windows_i686_gnu-0.42.2
	windows_i686_msvc-0.42.2
	windows_x86_64_gnu-0.42.2
	windows_x86_64_gnullvm-0.42.2
	windows_x86_64_msvc-0.42.2
"
inherit cargo

DESCRIPTION="Command-line tool for creating and testing tree-sitter grammars"
HOMEPAGE="https://github.com/tree-sitter/tree-sitter"
SRC_URI="https://github.com/${MY_PN}/${MY_PN}/archive/refs/tags/v${PV}.tar.gz -> ${MY_P}.tar.gz
$(cargo_crate_uris)"
S="${WORKDIR}"/${MY_P}/cli

LICENSE="Apache-2.0 BSD-2 CC0-1.0 ISC MIT"
SLOT="0"
KEYWORDS="amd64 arm arm64 ~loong ppc ppc64 ~riscv ~s390 sparc x86"

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
