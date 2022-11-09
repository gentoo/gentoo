# Copyright 2021-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
	aho-corasick-0.7.18
	ammonia-3.1.2
	ansi_term-0.12.1
	anyhow-1.0.43
	assert_cmd-1.0.7
	atty-0.2.14
	autocfg-1.0.1
	base64-0.13.0
	bit-set-0.5.2
	bit-vec-0.6.3
	bitflags-1.3.2
	block-buffer-0.7.3
	block-buffer-0.9.0
	block-padding-0.1.5
	bstr-0.2.17
	byte-tools-0.3.1
	byteorder-1.4.3
	bytes-1.0.1
	cfg-if-0.1.10
	cfg-if-1.0.0
	chrono-0.4.19
	clap-3.0.10
	clap_complete-3.0.4
	cpufeatures-0.1.5
	ctor-0.1.20
	diff-0.1.12
	difflib-0.4.0
	digest-0.8.1
	digest-0.9.0
	doc-comment-0.3.3
	either-1.6.1
	elasticlunr-rs-3.0.0
	env_logger-0.9.0
	fake-simd-0.1.2
	filetime-0.2.15
	float-cmp-0.9.0
	fnv-1.0.7
	form_urlencoded-1.0.1
	fsevent-0.4.0
	fsevent-sys-2.0.1
	fuchsia-zircon-0.3.3
	fuchsia-zircon-sys-0.3.3
	futf-0.1.4
	futures-channel-0.3.21
	futures-core-0.3.21
	futures-macro-0.3.16
	futures-sink-0.3.21
	futures-task-0.3.16
	futures-util-0.3.16
	generic-array-0.12.4
	generic-array-0.14.4
	getrandom-0.1.16
	getrandom-0.2.3
	gitignore-1.0.7
	glob-0.3.0
	h2-0.3.4
	handlebars-4.1.2
	hashbrown-0.11.2
	headers-0.3.4
	headers-core-0.2.0
	hermit-abi-0.1.19
	html5ever-0.25.1
	http-0.2.4
	http-body-0.4.3
	httparse-1.5.1
	httpdate-1.0.1
	humantime-2.1.0
	hyper-0.14.11
	idna-0.2.3
	indexmap-1.7.0
	inotify-0.7.1
	inotify-sys-0.1.5
	iovec-0.1.4
	itertools-0.10.1
	itoa-0.4.8
	kernel32-sys-0.2.2
	lazy_static-1.4.0
	lazycell-1.3.0
	libc-0.2.100
	log-0.4.14
	mac-0.1.1
	maplit-1.0.2
	markup5ever-0.10.1
	markup5ever_rcdom-0.1.0
	matches-0.1.9
	memchr-2.4.1
	mime-0.3.16
	mime_guess-2.0.3
	mio-0.6.23
	mio-0.7.13
	mio-extras-2.0.6
	miow-0.2.2
	miow-0.3.7
	net2-0.2.37
	new_debug_unreachable-1.0.4
	normalize-line-endings-0.3.0
	notify-4.0.17
	ntapi-0.3.6
	num-integer-0.1.44
	num-traits-0.2.14
	num_cpus-1.13.0
	opaque-debug-0.2.3
	opaque-debug-0.3.0
	opener-0.5.0
	os_str_bytes-6.0.0
	output_vt100-0.1.2
	percent-encoding-2.1.0
	pest-2.1.3
	pest_derive-2.1.0
	pest_generator-2.1.3
	pest_meta-2.1.3
	phf-0.8.0
	phf_codegen-0.8.0
	phf_generator-0.8.0
	phf_shared-0.8.0
	pin-project-1.0.8
	pin-project-internal-1.0.8
	pin-project-lite-0.2.7
	pin-utils-0.1.0
	ppv-lite86-0.2.10
	precomputed-hash-0.1.1
	predicates-2.0.1
	predicates-core-1.0.2
	predicates-tree-1.0.2
	pretty_assertions-1.2.1
	proc-macro-hack-0.5.19
	proc-macro-nested-0.1.7
	proc-macro2-1.0.28
	pulldown-cmark-0.9.1
	quick-error-2.0.1
	quote-1.0.9
	rand-0.7.3
	rand-0.8.4
	rand_chacha-0.2.2
	rand_chacha-0.3.1
	rand_core-0.5.1
	rand_core-0.6.3
	rand_hc-0.2.0
	rand_hc-0.3.1
	rand_pcg-0.2.1
	redox_syscall-0.2.10
	regex-1.5.5
	regex-automata-0.1.10
	regex-syntax-0.6.25
	remove_dir_all-0.5.3
	ryu-1.0.5
	same-file-1.0.6
	scoped-tls-1.0.0
	select-0.5.0
	semver-1.0.4
	serde-1.0.129
	serde_derive-1.0.129
	serde_json-1.0.66
	serde_urlencoded-0.7.0
	sha-1-0.8.2
	sha-1-0.9.7
	shlex-1.0.0
	siphasher-0.3.6
	slab-0.4.4
	socket2-0.4.1
	string_cache-0.8.1
	string_cache_codegen-0.5.1
	strsim-0.10.0
	syn-1.0.75
	tempfile-3.2.0
	tendril-0.4.2
	termcolor-1.1.2
	textwrap-0.14.2
	thiserror-1.0.31
	thiserror-impl-1.0.31
	time-0.1.43
	tinyvec-1.3.1
	tinyvec_macros-0.1.0
	tokio-1.16.1
	tokio-macros-1.8.0
	tokio-stream-0.1.7
	tokio-tungstenite-0.15.0
	tokio-util-0.6.7
	toml-0.5.8
	topological-sort-0.1.0
	tower-service-0.3.1
	tracing-0.1.26
	tracing-core-0.1.19
	treeline-0.1.0
	try-lock-0.2.3
	tungstenite-0.14.0
	typenum-1.13.0
	ucd-trie-0.1.3
	unicase-2.6.0
	unicode-bidi-0.3.6
	unicode-normalization-0.1.19
	unicode-xid-0.2.2
	url-2.2.2
	utf-8-0.7.6
	version_check-0.9.3
	wait-timeout-0.2.0
	walkdir-2.3.2
	want-0.3.0
	warp-0.3.2
	wasi-0.10.2+wasi-snapshot-preview1
	wasi-0.9.0+wasi-snapshot-preview1
	winapi-0.2.8
	winapi-0.3.9
	winapi-build-0.1.1
	winapi-i686-pc-windows-gnu-0.4.0
	winapi-util-0.1.5
	winapi-x86_64-pc-windows-gnu-0.4.0
	ws2_32-sys-0.2.1
	xml5ever-0.16.1"
inherit cargo toolchain-funcs

DESCRIPTION="Create a book from markdown files"
HOMEPAGE="https://rust-lang.github.io/mdBook/"
SRC_URI="
	https://github.com/rust-lang/mdBook/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
	$(cargo_crate_uris)"
S="${WORKDIR}/${P/b/B}"

# CC-BY-4.0/OFL-1.1: embeds fonts inside the executable
LICENSE="Apache-2.0 BSD CC-BY-4.0 CC0-1.0 ISC MIT MPL-2.0 OFL-1.1"
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
