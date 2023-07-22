# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..12} )
DISTUTILS_USE_PEP517=maturin

CRATES="
	Inflector-0.11.4
	adler-1.0.2
	aho-corasick-0.7.20
	aho-corasick-1.0.2
	android-tzdata-0.1.1
	android_system_properties-0.1.5
	anes-0.1.6
	annotate-snippets-0.6.1
	annotate-snippets-0.9.1
	anstream-0.3.2
	anstyle-1.0.1
	anstyle-parse-0.2.1
	anstyle-query-1.0.0
	anstyle-wincon-1.0.1
	anyhow-1.0.71
	argfile-0.1.5
	assert_cmd-2.0.11
	autocfg-1.1.0
	base64-0.21.2
	bincode-1.3.3
	bitflags-1.3.2
	bitflags-2.3.3
	bstr-1.6.0
	bumpalo-3.13.0
	cachedir-0.3.0
	cast-0.3.0
	cc-1.0.79
	cfg-if-1.0.0
	chic-1.2.2
	chrono-0.4.26
	ciborium-0.2.1
	ciborium-io-0.2.1
	ciborium-ll-0.2.1
	clap-4.3.11
	clap_builder-4.3.11
	clap_complete-4.3.2
	clap_complete_command-0.5.1
	clap_complete_fig-4.3.1
	clap_complete_nushell-0.1.11
	clap_derive-4.3.2
	clap_lex-0.5.0
	clearscreen-2.0.1
	colorchoice-1.0.0
	colored-2.0.4
	configparser-3.0.2
	console-0.15.7
	console_error_panic_hook-0.1.7
	console_log-1.0.0
	core-foundation-sys-0.8.4
	countme-3.0.1
	crc32fast-1.3.2
	criterion-0.5.1
	criterion-plot-0.5.0
	crossbeam-channel-0.5.8
	crossbeam-deque-0.8.3
	crossbeam-epoch-0.9.15
	crossbeam-utils-0.8.16
	crunchy-0.2.2
	ctor-0.1.26
	darling-0.20.1
	darling_core-0.20.1
	darling_macro-0.20.1
	diff-0.1.13
	difflib-0.4.0
	dirs-4.0.0
	dirs-5.0.1
	dirs-sys-0.3.7
	dirs-sys-0.4.1
	doc-comment-0.3.3
	drop_bomb-0.1.5
	dyn-clone-1.0.11
	either-1.8.1
	encode_unicode-0.3.6
	env_logger-0.10.0
	equivalent-1.0.0
	errno-0.3.1
	errno-dragonfly-0.1.2
	fastrand-1.9.0
	fern-0.6.2
	filetime-0.2.21
	flate2-1.0.26
	fnv-1.0.7
	form_urlencoded-1.2.0
	fs-err-2.9.0
	fsevent-sys-4.1.0
	getrandom-0.2.10
	glob-0.3.1
	globset-0.4.10
	half-1.8.2
	hashbrown-0.12.3
	hashbrown-0.14.0
	heck-0.4.1
	hermit-abi-0.3.2
	hex-0.4.3
	hexf-parse-0.2.1
	humantime-2.1.0
	iana-time-zone-0.1.57
	iana-time-zone-haiku-0.1.2
	ident_case-1.0.1
	idna-0.4.0
	ignore-0.4.20
	imperative-1.0.4
	indexmap-1.9.3
	indexmap-2.0.0
	indicatif-0.17.5
	indoc-2.0.3
	inotify-0.9.6
	inotify-sys-0.1.5
	insta-1.31.0
	instant-0.1.12
	io-lifetimes-1.0.11
	is-macro-0.2.2
	is-terminal-0.4.8
	itertools-0.10.5
	itoa-1.0.8
	js-sys-0.3.64
	kqueue-1.0.7
	kqueue-sys-1.0.3
	lalrpop-util-0.20.0
	lazy_static-1.4.0
	lexical-parse-float-0.8.5
	lexical-parse-integer-0.8.6
	lexical-util-0.8.5
	libc-0.2.147
	libmimalloc-sys-0.1.33
	linked-hash-map-0.5.6
	linux-raw-sys-0.3.8
	linux-raw-sys-0.4.3
	log-0.4.19
	matchers-0.1.0
	matches-0.1.10
	memchr-2.5.0
	memoffset-0.9.0
	mimalloc-0.1.37
	minimal-lexical-0.2.1
	miniz_oxide-0.7.1
	mio-0.8.8
	natord-1.0.9
	nextest-workspace-hack-0.1.0
	nix-0.26.2
	nohash-hasher-0.2.0
	nom-7.1.3
	notify-5.2.0
	nu-ansi-term-0.46.0
	num-bigint-0.4.3
	num-integer-0.1.45
	num-traits-0.2.15
	num_cpus-1.16.0
	number_prefix-0.4.0
	once_cell-1.18.0
	oorandom-11.1.3
	option-ext-0.2.0
	os_str_bytes-6.5.1
	output_vt100-0.1.3
	overload-0.1.1
	paste-1.0.13
	path-absolutize-3.1.0
	path-dedot-3.1.0
	pathdiff-0.2.1
	peg-0.8.1
	peg-macros-0.8.1
	peg-runtime-0.8.1
	pep440_rs-0.3.11
	pep508_rs-0.2.1
	percent-encoding-2.3.0
	phf-0.11.2
	phf_codegen-0.11.2
	phf_generator-0.11.2
	phf_macros-0.11.2
	phf_shared-0.11.2
	pin-project-lite-0.2.10
	plotters-0.3.5
	plotters-backend-0.3.5
	plotters-svg-0.3.5
	pmutil-0.5.3
	portable-atomic-1.3.3
	predicates-3.0.3
	predicates-core-1.0.6
	predicates-tree-1.0.9
	pretty_assertions-1.3.0
	proc-macro-error-1.0.4
	proc-macro-error-attr-1.0.4
	proc-macro2-1.0.63
	pyproject-toml-0.6.1
	quick-junit-0.3.2
	quick-xml-0.26.0
	quote-1.0.29
	rand-0.8.5
	rand_core-0.6.4
	rayon-1.7.0
	rayon-core-1.11.0
	redox_syscall-0.2.16
	redox_syscall-0.3.5
	redox_users-0.4.3
	regex-1.9.0
	regex-automata-0.1.10
	regex-automata-0.3.0
	regex-syntax-0.6.29
	regex-syntax-0.7.3
	result-like-0.4.6
	result-like-derive-0.4.6
	ring-0.16.20
	rust-stemmers-1.2.0
	rustc-hash-1.1.0
	rustix-0.37.23
	rustix-0.38.3
	rustls-0.21.2
	rustls-webpki-0.100.1
	rustversion-1.0.13
	ryu-1.0.14
	same-file-1.0.6
	schemars-0.8.12
	schemars_derive-0.8.12
	scoped-tls-1.0.1
	scopeguard-1.1.0
	sct-0.7.0
	semver-1.0.17
	serde-1.0.166
	serde-wasm-bindgen-0.5.0
	serde_derive-1.0.166
	serde_derive_internals-0.26.0
	serde_json-1.0.100
	serde_spanned-0.6.3
	serde_with-3.0.0
	serde_with_macros-3.0.0
	sharded-slab-0.1.4
	shellexpand-3.1.0
	shlex-1.1.0
	similar-2.2.1
	siphasher-0.3.10
	smallvec-1.10.0
	spin-0.5.2
	static_assertions-1.1.0
	strsim-0.10.0
	strum-0.24.1
	strum_macros-0.24.3
	syn-1.0.109
	syn-2.0.23
	syn-ext-0.4.0
	tempfile-3.6.0
	termcolor-1.2.0
	terminfo-0.8.0
	termtree-0.4.1
	test-case-3.1.0
	test-case-core-3.1.0
	test-case-macros-3.1.0
	thiserror-1.0.43
	thiserror-impl-1.0.43
	thread_local-1.1.7
	tikv-jemalloc-sys-0.5.3+5.3.0-patched
	tikv-jemallocator-0.5.0
	time-0.1.45
	time-0.3.22
	time-core-0.1.1
	time-macros-0.2.9
	tiny-keccak-2.0.2
	tinytemplate-1.2.1
	tinyvec-1.6.0
	tinyvec_macros-0.1.1
	toml-0.7.5
	toml_datetime-0.6.3
	toml_edit-0.19.11
	tracing-0.1.37
	tracing-attributes-0.1.26
	tracing-core-0.1.31
	tracing-log-0.1.3
	tracing-subscriber-0.3.17
	typed-arena-2.0.2
	unic-char-property-0.9.0
	unic-char-range-0.9.0
	unic-common-0.9.0
	unic-emoji-char-0.9.0
	unic-ucd-category-0.9.0
	unic-ucd-ident-0.9.0
	unic-ucd-version-0.9.0
	unicode-bidi-0.3.13
	unicode-ident-1.0.10
	unicode-normalization-0.1.22
	unicode-width-0.1.10
	untrusted-0.7.1
	ureq-2.7.1
	url-2.4.0
	utf8parse-0.2.1
	uuid-1.4.0
	valuable-0.1.0
	version_check-0.9.4
	wait-timeout-0.2.0
	walkdir-2.3.3
	wasi-0.10.0+wasi-snapshot-preview1
	wasi-0.11.0+wasi-snapshot-preview1
	wasm-bindgen-0.2.87
	wasm-bindgen-backend-0.2.87
	wasm-bindgen-futures-0.4.37
	wasm-bindgen-macro-0.2.87
	wasm-bindgen-macro-support-0.2.87
	wasm-bindgen-shared-0.2.87
	wasm-bindgen-test-0.3.37
	wasm-bindgen-test-macro-0.3.37
	web-sys-0.3.64
	webpki-roots-0.23.1
	which-4.4.0
	wild-2.1.0
	winapi-0.3.9
	winapi-i686-pc-windows-gnu-0.4.0
	winapi-util-0.1.5
	winapi-x86_64-pc-windows-gnu-0.4.0
	windows-0.48.0
	windows-sys-0.45.0
	windows-sys-0.48.0
	windows-targets-0.42.2
	windows-targets-0.48.1
	windows_aarch64_gnullvm-0.42.2
	windows_aarch64_gnullvm-0.48.0
	windows_aarch64_msvc-0.42.2
	windows_aarch64_msvc-0.48.0
	windows_i686_gnu-0.42.2
	windows_i686_gnu-0.48.0
	windows_i686_msvc-0.42.2
	windows_i686_msvc-0.48.0
	windows_x86_64_gnu-0.42.2
	windows_x86_64_gnu-0.48.0
	windows_x86_64_gnullvm-0.42.2
	windows_x86_64_gnullvm-0.48.0
	windows_x86_64_msvc-0.42.2
	windows_x86_64_msvc-0.48.0
	winnow-0.4.7
	wsl-0.1.0
	yaml-rust-0.4.5
	yansi-0.5.1
	yansi-term-0.1.2
"

LIBCST_COMMIT="3cacca1a1029f05707e50703b49fe3dd860aa839"
RUSTPYTHON_COMMIT="4d03b9b5b212fc869e4cfda151414438186a7779"
declare -A GIT_CRATES=(
	[libcst]="https://github.com/Instagram/LibCST;${LIBCST_COMMIT};LibCST-%commit%/native/libcst"
	[ruff_text_size]="https://github.com/astral-sh/RustPython-Parser;${RUSTPYTHON_COMMIT};RustPython-Parser-%commit%/ruff_text_size"
	[rustpython-ast]="https://github.com/astral-sh/RustPython-Parser;${RUSTPYTHON_COMMIT};RustPython-Parser-%commit%/ast"
	[rustpython-format]="https://github.com/astral-sh/RustPython-Parser;${RUSTPYTHON_COMMIT};RustPython-Parser-%commit%/format"
	[rustpython-literal]="https://github.com/astral-sh/RustPython-Parser;${RUSTPYTHON_COMMIT};RustPython-Parser-%commit%/literal"
	[rustpython-parser]="https://github.com/astral-sh/RustPython-Parser;${RUSTPYTHON_COMMIT};RustPython-Parser-%commit%/parser"
	[unicode_names2]="https://github.com/youknowone/unicode_names2;4ce16aa85cbcdd9cc830410f1a72ef9a235f2fde"
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
LICENSE="0BSD Apache-2.0 Apache-2.0-with-LLVM-exceptions Artistic-2 BSD BSD-2 Boost-1.0 CC0-1.0 ISC LGPL-3+ MIT MPL-2.0 Unicode-DFS-2016 Unlicense WTFPL-2 ZLIB"
SLOT="0"
#KEYWORDS="~amd64"

BDEPEND="
	dev-util/patchelf
	>=virtual/rust-1.71
"

# rust does not use *FLAGS from make.conf, silence portage warning
# update with proper path to binaries this crate installs, omit leading /
QA_FLAGS_IGNORED="usr/bin/.* usr/lib.*/libruff.*.so"

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

	[[ -n ${PATCHES[*]} ]] && eapply "${PATCHES[@]}"
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

	local solib
	for solib in $(find target/$(usex 'debug' 'debug' 'release') -maxdepth 1 -name '*.so'); do
		patchelf --set-soname "${solib##*/}" "${solib}" || die
	done
}

src_test() {
	cargo_src_test
	distutils-r1_src_test
}

src_install() {
	distutils-r1_src_install

	local releasedir=target/$(usex 'debug' 'debug' 'release')

	dobin ${releasedir}/{ruff{,_dev},flake8-to-ruff,ruff_python_formatter}
	dolib.so $(find target/$(usex 'debug' 'debug' 'release') -maxdepth 1 -name '*.so')

	dodoc "${DOCS[@]}"
}
