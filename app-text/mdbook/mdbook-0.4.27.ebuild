# Copyright 2021-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
	aho-corasick-0.7.20
	ammonia-3.3.0
	android_system_properties-0.1.5
	anyhow-1.0.69
	assert_cmd-2.0.8
	autocfg-1.1.0
	base64-0.13.1
	bit-set-0.5.3
	bit-vec-0.6.3
	bitflags-1.3.2
	block-buffer-0.10.3
	bstr-1.0.1
	bumpalo-3.11.1
	byteorder-1.4.3
	bytes-1.3.0
	cc-1.0.77
	cfg-if-1.0.0
	chrono-0.4.23
	clap-4.0.29
	clap_complete-4.0.6
	clap_lex-0.3.0
	codespan-reporting-0.11.1
	core-foundation-sys-0.8.3
	cpufeatures-0.2.5
	crossbeam-channel-0.5.6
	crossbeam-utils-0.8.14
	crypto-common-0.1.6
	ctor-0.1.26
	cxx-1.0.83
	cxx-build-1.0.83
	cxxbridge-flags-1.0.83
	cxxbridge-macro-1.0.83
	diff-0.1.13
	difflib-0.4.0
	digest-0.10.6
	doc-comment-0.3.3
	either-1.8.0
	elasticlunr-rs-3.0.1
	env_logger-0.10.0
	errno-0.2.8
	errno-dragonfly-0.1.2
	fastrand-1.8.0
	filetime-0.2.19
	float-cmp-0.9.0
	fnv-1.0.7
	form_urlencoded-1.1.0
	fsevent-sys-4.1.0
	futf-0.1.5
	futures-channel-0.3.25
	futures-core-0.3.25
	futures-macro-0.3.25
	futures-sink-0.3.25
	futures-task-0.3.25
	futures-util-0.3.25
	generic-array-0.14.6
	getrandom-0.2.8
	gitignore-1.0.7
	glob-0.3.0
	h2-0.3.15
	handlebars-4.3.6
	hashbrown-0.12.3
	headers-0.3.8
	headers-core-0.2.0
	hermit-abi-0.1.19
	hermit-abi-0.2.6
	html5ever-0.26.0
	http-0.2.8
	http-body-0.4.5
	httparse-1.8.0
	httpdate-1.0.2
	humantime-2.1.0
	hyper-0.14.23
	iana-time-zone-0.1.53
	iana-time-zone-haiku-0.1.1
	idna-0.3.0
	indexmap-1.9.2
	inotify-0.9.6
	inotify-sys-0.1.5
	instant-0.1.12
	io-lifetimes-1.0.3
	is-terminal-0.4.1
	itertools-0.10.5
	itoa-1.0.4
	js-sys-0.3.60
	kqueue-1.0.7
	kqueue-sys-1.0.3
	libc-0.2.138
	link-cplusplus-1.0.7
	linux-raw-sys-0.1.4
	lock_api-0.4.9
	log-0.4.17
	mac-0.1.1
	maplit-1.0.2
	markup5ever-0.11.0
	markup5ever_rcdom-0.2.0
	memchr-2.5.0
	mime-0.3.16
	mime_guess-2.0.4
	mio-0.8.5
	new_debug_unreachable-1.0.4
	normalize-line-endings-0.3.0
	notify-5.1.0
	notify-debouncer-mini-0.2.1
	num-integer-0.1.45
	num-traits-0.2.15
	num_cpus-1.14.0
	once_cell-1.17.0
	opener-0.5.2
	os_str_bytes-6.4.1
	output_vt100-0.1.3
	parking_lot-0.12.1
	parking_lot_core-0.9.5
	percent-encoding-2.2.0
	pest-2.5.1
	pest_derive-2.5.1
	pest_generator-2.5.1
	pest_meta-2.5.1
	phf-0.10.1
	phf_codegen-0.10.0
	phf_generator-0.10.0
	phf_shared-0.10.0
	pin-project-1.0.12
	pin-project-internal-1.0.12
	pin-project-lite-0.2.9
	pin-utils-0.1.0
	ppv-lite86-0.2.17
	precomputed-hash-0.1.1
	predicates-2.1.5
	predicates-core-1.0.5
	predicates-tree-1.0.7
	pretty_assertions-1.3.0
	proc-macro2-1.0.47
	pulldown-cmark-0.9.2
	quote-1.0.21
	rand-0.8.5
	rand_chacha-0.3.1
	rand_core-0.6.4
	redox_syscall-0.2.16
	regex-1.7.1
	regex-automata-0.1.10
	regex-syntax-0.6.28
	remove_dir_all-0.5.3
	rustix-0.36.5
	rustls-pemfile-0.2.1
	ryu-1.0.11
	same-file-1.0.6
	scoped-tls-1.0.1
	scopeguard-1.1.0
	scratch-1.0.2
	select-0.6.0
	semver-1.0.16
	serde-1.0.152
	serde_derive-1.0.152
	serde_json-1.0.93
	serde_urlencoded-0.7.1
	sha-1-0.10.1
	sha1-0.10.5
	shlex-1.1.0
	siphasher-0.3.10
	slab-0.4.7
	smallvec-1.10.0
	socket2-0.4.7
	string_cache-0.8.4
	string_cache_codegen-0.5.2
	strsim-0.10.0
	syn-1.0.105
	tempfile-3.3.0
	tendril-0.4.3
	termcolor-1.1.3
	terminal_size-0.2.3
	termtree-0.4.0
	thiserror-1.0.37
	thiserror-impl-1.0.37
	tinyvec-1.6.0
	tinyvec_macros-0.1.0
	tokio-1.25.0
	tokio-macros-1.8.2
	tokio-stream-0.1.11
	tokio-tungstenite-0.17.2
	tokio-util-0.7.4
	toml-0.5.10
	topological-sort-0.2.2
	tower-service-0.3.2
	tracing-0.1.37
	tracing-core-0.1.30
	try-lock-0.2.3
	tungstenite-0.17.3
	typenum-1.16.0
	ucd-trie-0.1.5
	unicase-2.6.0
	unicode-bidi-0.3.8
	unicode-ident-1.0.5
	unicode-normalization-0.1.22
	unicode-width-0.1.10
	url-2.3.1
	utf-8-0.7.6
	version_check-0.9.4
	wait-timeout-0.2.0
	walkdir-2.3.2
	want-0.3.0
	warp-0.3.3
	wasi-0.11.0+wasi-snapshot-preview1
	wasm-bindgen-0.2.83
	wasm-bindgen-backend-0.2.83
	wasm-bindgen-macro-0.2.83
	wasm-bindgen-macro-support-0.2.83
	wasm-bindgen-shared-0.2.83
	winapi-0.3.9
	winapi-i686-pc-windows-gnu-0.4.0
	winapi-util-0.1.5
	winapi-x86_64-pc-windows-gnu-0.4.0
	windows-sys-0.42.0
	windows_aarch64_gnullvm-0.42.0
	windows_aarch64_msvc-0.42.0
	windows_i686_gnu-0.42.0
	windows_i686_msvc-0.42.0
	windows_x86_64_gnu-0.42.0
	windows_x86_64_gnullvm-0.42.0
	windows_x86_64_msvc-0.42.0
	xml5ever-0.17.0
	yansi-0.5.1"
inherit cargo toolchain-funcs

DESCRIPTION="Create a book from markdown files"
HOMEPAGE="https://rust-lang.github.io/mdBook/"
SRC_URI="
	https://github.com/rust-lang/mdBook/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
	$(cargo_crate_uris)"
S="${WORKDIR}/${P/b/B}"

# CC-BY-4.0/OFL-1.1: embeds fonts inside the executable
LICENSE="Apache-2.0 Artistic-2 BSD CC-BY-4.0 CC0-1.0 ISC MIT MPL-2.0 OFL-1.1 Unicode-DFS-2016"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"
IUSE="doc"

QA_FLAGS_IGNORED="usr/bin/${PN}"

src_compile() {
	cargo_src_compile

	if use doc; then
		if tc-is-cross-compiler; then
			ewarn "html docs were skipped due to cross-compilation"
		else
			target/$(usex debug{,} release)/${PN} build -d html guide || die
		fi
	fi
}

src_install() {
	cargo_src_install

	dodoc CHANGELOG.md README.md

	[[ -e guide/html ]] && dodoc -r guide/html
}
