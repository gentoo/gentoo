# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
	adler-1.0.2
	ahash-0.7.6
	aho-corasick-0.7.20
	android_system_properties-0.1.5
	anes-0.1.6
	annotate-snippets-0.6.1
	annotate-snippets-0.9.1
	anyhow-1.0.69
	ascii-1.1.0
	ascii-canvas-3.0.0
	assert_cmd-2.0.8
	atty-0.2.14
	autocfg-1.1.0
	base64-0.13.1
	bincode-1.3.3
	bisection-0.1.0
	bit-set-0.5.3
	bit-vec-0.6.3
	bitflags-1.3.2
	block-buffer-0.10.3
	bstr-0.2.17
	bstr-1.2.0
	bumpalo-3.12.0
	cachedir-0.3.0
	cast-0.3.0
	cc-1.0.79
	cfg-if-1.0.0
	chic-1.2.2
	chrono-0.4.23
	ciborium-0.2.0
	ciborium-io-0.2.0
	ciborium-ll-0.2.0
	clap-3.2.23
	clap-4.1.6
	clap_complete-4.1.1
	clap_complete_command-0.4.0
	clap_complete_fig-4.1.0
	clap_derive-4.1.0
	clap_lex-0.2.4
	clap_lex-0.3.1
	clearscreen-2.0.0
	codespan-reporting-0.11.1
	colored-2.0.0
	configparser-3.0.2
	console-0.15.5
	console_error_panic_hook-0.1.7
	console_log-0.2.0
	core-foundation-sys-0.8.3
	cpufeatures-0.2.5
	crc32fast-1.3.2
	criterion-0.4.0
	criterion-plot-0.5.0
	crossbeam-channel-0.5.6
	crossbeam-deque-0.8.2
	crossbeam-epoch-0.9.13
	crossbeam-utils-0.8.14
	crunchy-0.2.2
	crypto-common-0.1.6
	cxx-1.0.90
	cxx-build-1.0.90
	cxxbridge-flags-1.0.90
	cxxbridge-macro-1.0.90
	diff-0.1.13
	difflib-0.4.0
	digest-0.10.6
	dirs-4.0.0
	dirs-next-2.0.0
	dirs-sys-0.3.7
	dirs-sys-next-0.1.2
	doc-comment-0.3.3
	drop_bomb-0.1.5
	dyn-clone-1.0.10
	either-1.8.1
	ena-0.14.0
	encode_unicode-0.3.6
	errno-0.2.8
	errno-dragonfly-0.1.2
	fastrand-1.9.0
	fern-0.6.1
	filetime-0.2.20
	fixedbitset-0.4.2
	flate2-1.0.25
	fnv-1.0.7
	form_urlencoded-1.1.0
	fsevent-sys-4.1.0
	generic-array-0.14.6
	getrandom-0.2.8
	glob-0.3.1
	globset-0.4.10
	half-1.8.2
	hashbrown-0.12.3
	heck-0.4.1
	hermit-abi-0.1.19
	hermit-abi-0.2.6
	hermit-abi-0.3.1
	hexf-parse-0.2.1
	iana-time-zone-0.1.53
	iana-time-zone-haiku-0.1.1
	idna-0.3.0
	ignore-0.4.20
	imperative-1.0.4
	indexmap-1.9.2
	inotify-0.9.6
	inotify-sys-0.1.5
	insta-1.26.0
	instant-0.1.12
	io-lifetimes-1.0.5
	is-terminal-0.4.3
	itertools-0.10.5
	itoa-1.0.5
	joinery-2.1.0
	js-sys-0.3.61
	kqueue-1.0.7
	kqueue-sys-1.0.3
	lalrpop-0.19.8
	lalrpop-util-0.19.8
	lazy_static-1.4.0
	lexical-parse-float-0.8.5
	lexical-parse-integer-0.8.6
	lexical-util-0.8.5
	libc-0.2.139
	libmimalloc-sys-0.1.30
	link-cplusplus-1.0.8
	linked-hash-map-0.5.6
	linux-raw-sys-0.1.4
	lock_api-0.4.9
	log-0.4.17
	lz4_flex-0.9.5
	matches-0.1.10
	memchr-2.5.0
	memoffset-0.7.1
	mimalloc-0.1.34
	miniz_oxide-0.6.2
	mio-0.8.5
	natord-1.0.9
	new_debug_unreachable-1.0.4
	nextest-workspace-hack-0.1.0
	nix-0.26.2
	nohash-hasher-0.2.0
	nom-5.1.2
	nom8-0.2.0
	notify-5.1.0
	num-bigint-0.4.3
	num-complex-0.4.3
	num-integer-0.1.45
	num-traits-0.2.15
	num_cpus-1.15.0
	num_enum-0.5.9
	num_enum_derive-0.5.9
	once_cell-1.17.0
	oorandom-11.1.3
	os_str_bytes-6.4.1
	parking_lot-0.12.1
	parking_lot_core-0.9.7
	paste-1.0.11
	path-absolutize-3.0.14
	path-dedot-3.0.18
	peg-0.8.1
	peg-macros-0.8.1
	peg-runtime-0.8.1
	percent-encoding-2.2.0
	pest-2.5.5
	pest_derive-2.5.5
	pest_generator-2.5.5
	pest_meta-2.5.5
	petgraph-0.6.3
	phf-0.11.1
	phf_codegen-0.11.1
	phf_generator-0.11.1
	phf_shared-0.10.0
	phf_shared-0.11.1
	pico-args-0.4.2
	pin-project-lite-0.2.9
	plotters-0.3.4
	plotters-backend-0.3.4
	plotters-svg-0.3.3
	ppv-lite86-0.2.17
	precomputed-hash-0.1.1
	predicates-2.1.5
	predicates-core-1.0.5
	predicates-tree-1.0.7
	proc-macro-crate-1.3.0
	proc-macro-error-1.0.4
	proc-macro-error-attr-1.0.4
	proc-macro2-1.0.51
	quick-junit-0.3.2
	quick-xml-0.26.0
	quote-1.0.23
	radium-0.7.0
	rand-0.8.5
	rand_chacha-0.3.1
	rand_core-0.6.4
	rayon-1.6.1
	rayon-core-1.10.2
	redox_syscall-0.2.16
	redox_users-0.4.3
	regex-1.7.1
	regex-automata-0.1.10
	regex-syntax-0.6.28
	remove_dir_all-0.5.3
	ring-0.16.20
	rust-stemmers-1.2.0
	rustc-hash-1.1.0
	rustix-0.36.8
	rustls-0.20.8
	rustversion-1.0.11
	ryu-1.0.12
	same-file-1.0.6
	schemars-0.8.11
	schemars_derive-0.8.11
	scoped-tls-1.0.1
	scopeguard-1.1.0
	scratch-1.0.3
	sct-0.7.0
	semver-1.0.16
	serde-1.0.152
	serde-wasm-bindgen-0.4.5
	serde_derive-1.0.152
	serde_derive_internals-0.26.0
	serde_json-1.0.93
	serde_spanned-0.6.1
	serde_test-1.0.152
	sha2-0.10.6
	shellexpand-3.0.0
	similar-2.2.1
	siphasher-0.3.10
	smallvec-1.10.0
	smawk-0.3.1
	spin-0.5.2
	static_assertions-1.1.0
	string_cache-0.8.4
	strsim-0.10.0
	strum-0.24.1
	strum_macros-0.24.3
	syn-1.0.107
	tempfile-3.3.0
	term-0.7.0
	termcolor-1.2.0
	terminfo-0.7.5
	termtree-0.4.0
	test-case-2.2.2
	test-case-macros-2.2.2
	textwrap-0.16.0
	thiserror-1.0.38
	thiserror-impl-1.0.38
	thread_local-1.1.7
	tikv-jemalloc-sys-0.5.3+5.3.0-patched
	tikv-jemallocator-0.5.0
	time-0.1.45
	tiny-keccak-2.0.2
	tinytemplate-1.2.1
	tinyvec-1.6.0
	tinyvec_macros-0.1.1
	titlecase-2.2.1
	toml-0.6.0
	toml_datetime-0.5.1
	toml_edit-0.18.1
	tracing-0.1.37
	tracing-core-0.1.30
	twox-hash-1.6.3
	typenum-1.16.0
	ucd-trie-0.1.5
	unic-char-property-0.9.0
	unic-char-range-0.9.0
	unic-common-0.9.0
	unic-emoji-char-0.9.0
	unic-ucd-category-0.9.0
	unic-ucd-ident-0.9.0
	unic-ucd-version-0.9.0
	unicode-bidi-0.3.10
	unicode-ident-1.0.6
	unicode-linebreak-0.1.4
	unicode-normalization-0.1.22
	unicode-width-0.1.10
	unicode-xid-0.2.4
	unicode_names2-0.5.1
	untrusted-0.7.1
	ureq-2.6.2
	url-2.3.1
	uuid-1.3.0
	version_check-0.9.4
	volatile-0.3.0
	wait-timeout-0.2.0
	walkdir-2.3.2
	wasi-0.10.0+wasi-snapshot-preview1
	wasi-0.11.0+wasi-snapshot-preview1
	wasm-bindgen-0.2.84
	wasm-bindgen-backend-0.2.84
	wasm-bindgen-futures-0.4.34
	wasm-bindgen-macro-0.2.84
	wasm-bindgen-macro-support-0.2.84
	wasm-bindgen-shared-0.2.84
	wasm-bindgen-test-0.3.34
	wasm-bindgen-test-macro-0.3.34
	web-sys-0.3.61
	webpki-0.22.0
	webpki-roots-0.22.6
	which-4.4.0
	widestring-0.5.1
	winapi-0.3.9
	winapi-i686-pc-windows-gnu-0.4.0
	winapi-util-0.1.5
	winapi-x86_64-pc-windows-gnu-0.4.0
	windows-sys-0.42.0
	windows-sys-0.45.0
	windows-targets-0.42.1
	windows_aarch64_gnullvm-0.42.1
	windows_aarch64_msvc-0.42.1
	windows_i686_gnu-0.42.1
	windows_i686_msvc-0.42.1
	windows_x86_64_gnu-0.42.1
	windows_x86_64_gnullvm-0.42.1
	windows_x86_64_msvc-0.42.1
	yaml-rust-0.4.5
	yansi-term-0.1.2
"

PYTHON_COMPAT=( python3_{9..11} )
DISTUTILS_USE_PEP517=maturin

LIBCST_COMMIT="f2f0b7a487a8725d161fe8b3ed73a6758b21e177"
RUSTPYTHON_COMMIT="edf5995a1e4c366976304ca05432dd27c913054e"
declare -A GIT_CRATES=(
	[libcst]="https://github.com/charliermarsh/LibCST;${LIBCST_COMMIT};LibCST-%commit%/native/libcst"
	[libcst_derive]="https://github.com/charliermarsh/LibCST;${LIBCST_COMMIT};LibCST-%commit%/native/libcst_derive"
	[rustpython-ast]="https://github.com/RustPython/RustPython;${RUSTPYTHON_COMMIT};RustPython-%commit%/compiler/ast"
	[rustpython-common]="https://github.com/RustPython/RustPython;${RUSTPYTHON_COMMIT};RustPython-%commit%/common"
	[rustpython-compiler-core]="https://github.com/RustPython/RustPython;${RUSTPYTHON_COMMIT};RustPython-%commit%/compiler/core"
	[rustpython-parser]="https://github.com/RustPython/RustPython;${RUSTPYTHON_COMMIT};RustPython-%commit%/compiler/parser"
)

inherit distutils-r1 cargo

DESCRIPTION="An extremely fast Python linter, written in Rust"
# Double check the homepage as the cargo_metadata crate
# does not provide this value so instead repository is used
HOMEPAGE="https://github.com/charliermarsh/ruff"

SRC_URI="
	$(cargo_crate_uris)
	https://github.com/charliermarsh/ruff/archive/refs/tags/v${PV}.tar.gz -> ${P}.gh.tar.gz
"

# License set may be more restrictive as OR is not respected
# use cargo-license for a more accurate license picture
LICENSE="0BSD Apache-2.0 Apache-2.0-with-LLVM-exceptions Artistic-2 BSD Boost-1.0 CC0-1.0 ISC LGPL-3+ MIT MPL-2.0 Unicode-DFS-2016 Unlicense WTFPL-2 ZLIB"
SLOT="0"
KEYWORDS="~amd64"

BDEPEND="
	dev-util/patchelf
"

# rust does not use *FLAGS from make.conf, silence portage warning
# update with proper path to binaries this crate installs, omit leading /
QA_FLAGS_IGNORED="usr/bin/ruff usr/lib.*/libruff.so"

# haven't been able to figure out how to get tests working yet
RESTRICT=test

DOCS=(
	BREAKING_CHANGES.md
	CODE_OF_CONDUCT.md
	CONTRIBUTING.md
	README.md
)

src_prepare() {
	sed -r 's:(strip[[:space:]]*=[[:space:]]*)true:\1false:' \
		-i pyproject.toml || die

	eapply_user
}

src_configure() {
	export RUSTFLAGS="${RUSTFLAGS}"
	cargo_src_configure
}

src_compile() {
	cargo_src_compile

	python_copy_sources
	distutils-r1_src_configure
	distutils-r1_src_compile

	patchelf --set-soname libruff.so target/$(usex 'debug' 'debug' 'release')/libruff.so || die
}

src_test() {
	cargo_src_test
	distutils-r1_src_test
}

src_install() {
	distutils-r1_src_install

	local releasedir=target/$(usex 'debug' 'debug' 'release')

	dobin ${releasedir}/ruff
	dolib.so ${releasedir}/libruff.so

	dodoc "${DOCS[@]}"
}
