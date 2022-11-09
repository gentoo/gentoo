# Copyright 2021-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
	abscissa_core-0.6.0
	abscissa_derive-0.6.0
	addr2line-0.17.0
	adler-1.0.2
	aho-corasick-0.7.18
	ansi_term-0.12.1
	anyhow-1.0.56
	arc-swap-1.5.0
	askama-0.11.1
	askama_derive-0.11.2
	askama_escape-0.10.3
	askama_shared-0.12.2
	atom_syndication-0.11.0
	atty-0.2.14
	autocfg-1.1.0
	backtrace-0.3.64
	base64-0.13.0
	bincode-1.3.3
	bitflags-1.3.2
	block-buffer-0.7.3
	block-buffer-0.9.0
	block-padding-0.1.5
	bumpalo-3.9.1
	byte-tools-0.3.1
	byteorder-1.4.3
	bytes-1.1.0
	camino-1.0.7
	canonical-path-2.0.2
	cargo-edit-0.9.1
	cargo-platform-0.1.2
	cargo_metadata-0.14.2
	cc-1.0.73
	cfg-if-1.0.0
	chrono-0.4.19
	chunked_transfer-1.4.0
	clap-2.34.0
	clap-3.1.18
	clap_derive-3.1.18
	clap_lex-0.2.0
	color-eyre-0.6.1
	combine-4.6.3
	comrak-0.12.1
	concolor-control-0.0.7
	concolor-query-0.0.4
	core-foundation-0.9.3
	core-foundation-sys-0.8.3
	cpufeatures-0.2.2
	crates-index-0.18.7
	crc32fast-1.3.2
	crossbeam-channel-0.5.4
	crossbeam-deque-0.8.1
	crossbeam-epoch-0.9.8
	crossbeam-utils-0.8.8
	darling-0.12.4
	darling_core-0.12.4
	darling_macro-0.12.4
	derive_builder-0.10.2
	derive_builder_core-0.10.2
	derive_builder_macro-0.10.2
	digest-0.8.1
	digest-0.9.0
	diligent-date-parser-0.1.3
	dirs-4.0.0
	dirs-next-2.0.0
	dirs-sys-0.3.7
	dirs-sys-next-0.1.2
	dunce-1.0.2
	either-1.6.1
	encoding_rs-0.8.31
	entities-1.0.1
	env_proxy-0.4.1
	eyre-0.6.8
	fake-simd-0.1.2
	fastrand-1.7.0
	fixedbitset-0.4.1
	flate2-1.0.23
	fnv-1.0.7
	foreign-types-0.3.2
	foreign-types-shared-0.1.1
	form_urlencoded-1.0.1
	fs-err-2.7.0
	generic-array-0.12.4
	generic-array-0.14.5
	getrandom-0.2.6
	gimli-0.26.1
	git2-0.14.2
	gumdrop-0.8.1
	gumdrop_derive-0.8.1
	hashbrown-0.11.2
	heck-0.4.0
	hermit-abi-0.1.19
	hex-0.4.3
	home-0.5.3
	humansize-1.1.1
	humantime-2.1.0
	humantime-serde-1.1.1
	ident_case-1.0.1
	idna-0.2.3
	indenter-0.3.3
	indexmap-1.8.1
	instant-0.1.12
	itertools-0.10.3
	itoa-1.0.1
	jobserver-0.1.24
	js-sys-0.3.57
	kstring-1.0.6
	lazy_static-1.4.0
	lazycell-1.3.0
	libc-0.2.123
	libgit2-sys-0.13.2+1.4.2
	libssh2-sys-0.2.23
	libz-sys-1.1.5
	line-wrap-0.1.1
	linked-hash-map-0.5.4
	log-0.4.16
	maplit-1.0.2
	matchers-0.1.0
	matches-0.1.9
	memchr-2.4.1
	memoffset-0.6.5
	mime-0.3.16
	mime_guess-2.0.4
	minimal-lexical-0.2.1
	miniz_oxide-0.4.4
	miniz_oxide-0.5.1
	native-tls-0.2.10
	never-0.1.0
	nom-7.1.1
	num-integer-0.1.44
	num-traits-0.2.14
	num_cpus-1.13.1
	num_threads-0.1.5
	object-0.27.1
	once_cell-1.10.0
	onig-6.3.1
	onig_sys-69.7.1
	opaque-debug-0.2.3
	opaque-debug-0.3.0
	openssl-0.10.38
	openssl-probe-0.1.5
	openssl-src-111.18.0+1.1.1n
	openssl-sys-0.9.72
	os_str_bytes-6.0.0
	owo-colors-3.3.0
	pathdiff-0.2.1
	percent-encoding-2.1.0
	pest-2.1.3
	pest_derive-2.1.0
	pest_generator-2.1.3
	pest_meta-2.1.3
	petgraph-0.6.0
	pin-project-lite-0.2.8
	pkg-config-0.3.25
	plist-1.3.1
	proc-macro-error-1.0.4
	proc-macro-error-attr-1.0.4
	proc-macro2-1.0.37
	quick-xml-0.22.0
	quote-1.0.18
	rayon-1.5.2
	rayon-core-1.9.2
	redox_syscall-0.2.13
	redox_users-0.4.3
	regex-1.5.5
	regex-automata-0.1.10
	regex-syntax-0.6.25
	remove_dir_all-0.5.3
	ring-0.16.20
	rust-embed-6.4.0
	rust-embed-impl-6.2.0
	rust-embed-utils-7.2.0
	rustc-demangle-0.1.21
	rustc-hash-1.1.0
	rustls-0.20.4
	ryu-1.0.9
	safemem-0.3.3
	same-file-1.0.6
	schannel-0.1.19
	scopeguard-1.1.0
	sct-0.7.0
	secrecy-0.8.0
	security-framework-2.6.1
	security-framework-sys-2.6.1
	semver-1.0.9
	serde-1.0.136
	serde_derive-1.0.136
	serde_json-1.0.79
	sha-1-0.8.2
	sha2-0.9.9
	sharded-slab-0.1.4
	shell-words-1.1.0
	smallvec-1.8.0
	smartstring-1.0.1
	socks-0.3.4
	spin-0.5.2
	static_assertions-1.1.0
	strsim-0.8.0
	strsim-0.10.0
	subprocess-0.2.8
	syn-1.0.91
	synstructure-0.12.6
	syntect-4.6.0
	tempfile-3.3.0
	termcolor-1.1.3
	terminal_size-0.1.17
	textwrap-0.11.0
	textwrap-0.15.0
	thiserror-1.0.30
	thiserror-impl-1.0.30
	thread_local-1.1.4
	time-0.1.43
	time-0.3.9
	tinyvec-1.5.1
	tinyvec_macros-0.1.0
	toml-0.5.9
	toml_edit-0.13.4
	tracing-0.1.34
	tracing-attributes-0.1.20
	tracing-core-0.1.26
	tracing-log-0.1.2
	tracing-subscriber-0.3.11
	twoway-0.2.2
	typed-arena-1.7.0
	typenum-1.15.0
	ucd-trie-0.1.3
	unchecked-index-0.2.2
	unicase-2.6.0
	unicode-bidi-0.3.7
	unicode-normalization-0.1.19
	unicode-width-0.1.9
	unicode-xid-0.2.2
	unicode_categories-0.1.1
	untrusted-0.7.1
	ureq-2.4.0
	url-2.2.2
	valuable-0.1.0
	vcpkg-0.2.15
	vec_map-0.8.2
	version_check-0.9.4
	wait-timeout-0.2.0
	walkdir-2.3.2
	wasi-0.10.2+wasi-snapshot-preview1
	wasm-bindgen-0.2.80
	wasm-bindgen-backend-0.2.80
	wasm-bindgen-macro-0.2.80
	wasm-bindgen-macro-support-0.2.80
	wasm-bindgen-shared-0.2.80
	web-sys-0.3.57
	webpki-0.22.0
	webpki-roots-0.22.3
	winapi-0.3.9
	winapi-i686-pc-windows-gnu-0.4.0
	winapi-util-0.1.5
	winapi-x86_64-pc-windows-gnu-0.4.0
	xdg-2.4.1
	xml-rs-0.8.4
	yaml-rust-0.4.5
	zeroize-1.5.4
"

inherit cargo

DESCRIPTION="Audit Cargo.lock for security vulnerabilities"
HOMEPAGE="https://github.com/rustsec/cargo-audit"
SRC_URI="https://github.com/RustSec/rustsec/archive/refs/tags/${PN}/v${PV}.tar.gz -> ${P}.tar.gz
	$(cargo_crate_uris)"

LICENSE="Apache-2.0 Apache-2.0-with-LLVM-exceptions Boost-1.0 MIT MPL-2.0 Unlicense"
SLOT="0"
KEYWORDS="~amd64 ~ppc64"
IUSE="fix"

RDEPEND="dev-libs/openssl:0="
DEPEND="${RDEPEND}"

S="${WORKDIR}/rustsec-${PN}-v${PV}"

QA_FLAGS_IGNORED="usr/bin/${PN}"

# requires checkout of vuln db/network
PROPERTIES="test_network"
RESTRICT="test"

src_configure() {
	local myfeatures=(
		$(usev fix)
		vendored-libgit2
	)

	cargo_src_configure
}

src_compile() {
	# normally we can pass --bin cargo-audit
	# to build single workspace member, but we need to cd
	# for tests to be discovered properly
	cd cargo-audit || die
	cargo_src_compile
}

src_install() {
	cargo_src_install --path cargo-audit
	local DOCS=( cargo-audit/{README.md,audit.toml.example} )
	einstalldocs
}
