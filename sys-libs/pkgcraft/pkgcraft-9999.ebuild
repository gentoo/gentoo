# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
	adler-1.0.2
	ahash-0.7.6
	aho-corasick-0.7.20
	anes-0.1.6
	annotate-snippets-0.6.1
	anyhow-1.0.68
	assert_cmd-2.0.8
	async-stream-0.3.3
	async-stream-impl-0.3.3
	async-trait-0.1.64
	async_once-0.2.6
	atty-0.2.14
	autocfg-1.1.0
	autotools-0.2.5
	axum-0.6.4
	axum-core-0.3.2
	base64-0.13.1
	base64-0.21.0
	bindgen-0.63.0
	bitflags-1.3.2
	bstr-1.2.0
	bumpalo-3.12.0
	bytes-1.4.0
	cached-0.42.0
	cached_proc_macro-0.16.0
	cached_proc_macro_types-0.1.0
	camino-1.1.2
	cast-0.3.0
	cc-1.0.79
	cexpr-0.6.0
	cfg-if-1.0.0
	chic-1.2.2
	ciborium-0.2.0
	ciborium-io-0.2.0
	ciborium-ll-0.2.0
	clang-sys-1.4.0
	clap-3.2.23
	clap-4.1.4
	clap_derive-4.1.0
	clap_lex-0.2.4
	clap_lex-0.3.1
	config-0.13.3
	crc32fast-1.3.2
	criterion-0.4.0
	criterion-plot-0.5.0
	crossbeam-channel-0.5.6
	crossbeam-deque-0.8.2
	crossbeam-epoch-0.9.13
	crossbeam-utils-0.8.14
	ctor-0.1.26
	darling-0.14.2
	darling_core-0.14.2
	darling_macro-0.14.2
	difflib-0.4.0
	dlv-list-0.3.0
	doc-comment-0.3.3
	either-1.8.1
	encoding_rs-0.8.32
	enum-as-inner-0.5.1
	errno-0.2.8
	errno-dragonfly-0.1.2
	fastrand-1.8.0
	filetime-0.2.19
	fixedbitset-0.4.2
	flate2-1.0.25
	fnv-1.0.7
	form_urlencoded-1.1.0
	futures-0.3.26
	futures-channel-0.3.26
	futures-core-0.3.26
	futures-executor-0.3.26
	futures-io-0.3.26
	futures-macro-0.3.26
	futures-sink-0.3.26
	futures-task-0.3.26
	futures-util-0.3.26
	getrandom-0.2.8
	git2-0.16.1
	glob-0.3.1
	h2-0.3.15
	half-1.8.2
	hashbrown-0.12.3
	hashbrown-0.13.2
	heck-0.4.1
	hermit-abi-0.1.19
	hermit-abi-0.2.6
	hermit-abi-0.3.0
	http-0.2.8
	http-body-0.4.5
	http-range-header-0.3.0
	httparse-1.8.0
	httpdate-1.0.2
	hyper-0.14.24
	hyper-rustls-0.23.2
	hyper-timeout-0.4.1
	ident_case-1.0.1
	idna-0.3.0
	indexmap-1.9.2
	indoc-2.0.0
	instant-0.1.12
	io-lifetimes-1.0.5
	ipnet-2.7.1
	is-terminal-0.4.3
	is_executable-1.0.1
	itertools-0.10.5
	itoa-1.0.5
	jobserver-0.1.25
	js-sys-0.3.61
	lazy_static-1.4.0
	lazycell-1.3.0
	libc-0.2.139
	libgit2-sys-0.14.2+1.5.1
	libloading-0.7.4
	libssh2-sys-0.2.23
	libz-sys-1.1.8
	linux-raw-sys-0.1.4
	lock_api-0.4.9
	log-0.4.17
	maplit-1.0.2
	matchers-0.1.0
	matchit-0.7.0
	memchr-2.5.0
	memoffset-0.7.1
	mime-0.3.16
	minimal-lexical-0.2.1
	miniz_oxide-0.6.2
	mio-0.8.5
	multimap-0.8.3
	nix-0.26.2
	nom-7.1.3
	nom8-0.2.0
	nu-ansi-term-0.46.0
	num-traits-0.2.15
	num_cpus-1.15.0
	once_cell-1.17.0
	oorandom-11.1.3
	openssl-probe-0.1.5
	openssl-sys-0.9.80
	ordered-multimap-0.4.3
	os_str_bytes-6.4.1
	overload-0.1.1
	parking_lot-0.12.1
	parking_lot_core-0.9.7
	pathdiff-0.2.1
	peeking_take_while-0.1.2
	peg-0.8.1
	peg-macros-0.8.1
	peg-runtime-0.8.1
	percent-encoding-2.2.0
	petgraph-0.6.2
	pin-project-1.0.12
	pin-project-internal-1.0.12
	pin-project-lite-0.2.9
	pin-utils-0.1.0
	pkg-config-0.3.26
	plotters-0.3.4
	plotters-backend-0.3.4
	plotters-svg-0.3.3
	ppv-lite86-0.2.17
	predicates-2.1.5
	predicates-core-1.0.5
	predicates-tree-1.0.7
	prettyplease-0.1.23
	proc-macro-error-1.0.4
	proc-macro-error-attr-1.0.4
	proc-macro2-1.0.50
	prost-0.11.6
	prost-build-0.11.6
	prost-derive-0.11.6
	prost-types-0.11.6
	quote-1.0.23
	rand-0.8.5
	rand_chacha-0.3.1
	rand_core-0.6.4
	rayon-1.6.1
	rayon-core-1.10.2
	redox_syscall-0.2.16
	regex-1.7.1
	regex-automata-0.1.10
	regex-syntax-0.6.28
	remove_dir_all-0.5.3
	reqwest-0.11.14
	ring-0.16.20
	roxmltree-0.18.0
	rust-ini-0.18.0
	rustc-hash-1.1.0
	rustix-0.36.8
	rustls-0.20.8
	rustls-pemfile-1.0.2
	rustversion-1.0.11
	ryu-1.0.12
	same-file-1.0.6
	scopeguard-1.1.0
	sct-0.7.0
	serde-1.0.152
	serde_derive-1.0.152
	serde_json-1.0.91
	serde_spanned-0.6.1
	serde_urlencoded-0.7.1
	serde_with-2.2.0
	serde_with_macros-2.2.0
	sharded-slab-0.1.4
	shlex-1.1.0
	signal-hook-registry-1.4.0
	slab-0.4.7
	smallvec-1.10.0
	socket2-0.4.7
	spin-0.5.2
	static_assertions-1.1.0
	strsim-0.10.0
	strum-0.24.1
	strum_macros-0.24.3
	syn-1.0.107
	sync_wrapper-0.1.2
	sys-info-0.9.1
	tar-0.4.38
	tempfile-3.3.0
	termcolor-1.2.0
	termtree-0.4.0
	textwrap-0.16.0
	thiserror-1.0.38
	thiserror-impl-1.0.38
	thread_local-1.1.4
	tinytemplate-1.2.1
	tinyvec-1.6.0
	tinyvec_macros-0.1.1
	tokio-1.25.0
	tokio-io-timeout-1.2.0
	tokio-macros-1.8.2
	tokio-rustls-0.23.4
	tokio-stream-0.1.11
	tokio-util-0.7.4
	toml-0.5.11
	toml-0.7.1
	toml_datetime-0.6.1
	toml_edit-0.19.1
	tonic-0.8.3
	tonic-build-0.8.4
	tower-0.4.13
	tower-http-0.3.5
	tower-layer-0.3.2
	tower-service-0.3.2
	tracing-0.1.37
	tracing-attributes-0.1.23
	tracing-core-0.1.30
	tracing-futures-0.2.5
	tracing-log-0.1.3
	tracing-subscriber-0.3.16
	tracing-test-0.2.4
	tracing-test-macro-0.2.4
	try-lock-0.2.4
	unicode-bidi-0.3.10
	unicode-ident-1.0.6
	unicode-normalization-0.1.22
	untrusted-0.7.1
	url-2.3.1
	valuable-0.1.0
	vcpkg-0.2.15
	version_check-0.9.4
	wait-timeout-0.2.0
	walkdir-2.3.2
	want-0.3.0
	wasi-0.11.0+wasi-snapshot-preview1
	wasm-bindgen-0.2.84
	wasm-bindgen-backend-0.2.84
	wasm-bindgen-futures-0.4.34
	wasm-bindgen-macro-0.2.84
	wasm-bindgen-macro-support-0.2.84
	wasm-bindgen-shared-0.2.84
	wasm-streams-0.2.3
	web-sys-0.3.61
	webpki-0.22.0
	webpki-roots-0.22.6
	which-4.4.0
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
	winreg-0.10.1
	xattr-0.2.3
	xmlparser-0.13.5
"

inherit edo cargo toolchain-funcs

DESCRIPTION="C library for pkgcraft"
HOMEPAGE="https://pkgcraft.github.io/"

if [[ ${PV} == 9999 ]] ; then
	EGIT_REPO_URI="https://github.com/pkgcraft/pkgcraft"
	inherit git-r3

	S="${WORKDIR}"/${P}/crates/pkgcraft-c

	BDEPEND="test? ( dev-util/cargo-nextest )"
else
	export BASH_SUBMODULE_COMMIT="4c79d69fbfc508b78ef480e2449e81b244f59ab1"
	SRC_URI="
		https://github.com/pkgcraft/pkgcraft/archive/refs/tags/${PN}-c-${PV}.tar.gz
		https://github.com/pkgcraft/bash/archive/${BASH_SUBMODULE_COMMIT}.tar.gz -> ${PN}-bash-${BASH_SUBMODULE_COMMIT}.tar.gz
		$(cargo_crate_uris)
	"

	S="${WORKDIR}"/${PN}-${PN}-c-${PV}/crates/${PN}-c
	KEYWORDS="~amd64"
fi

LICENSE="MIT"
# Dependent crate licenses
LICENSE+=" Apache-2.0 BSD ISC MIT MPL-2.0 Unicode-DFS-2016"
SLOT="0/${PV}"
IUSE="test"
RESTRICT="!test? ( test )"

# clang needed for bindgen
BDEPEND+="
	dev-util/cargo-c
	sys-devel/clang
	>=virtual/rust-1.65
"

QA_FLAGS_IGNORED="usr/lib.*/libpkgcraft.so.*"

src_unpack() {
	if [[ ${PV} == 9999 ]] ; then
		git-r3_src_unpack
		cargo_live_src_unpack
	else
		cargo_src_unpack
	fi
}

src_prepare() {
	default

	if [[ ${PV} != 9999 ]] ; then
		rm -rvf ../scallop/bash || die
		ln -sv "${WORKDIR}/bash-"* ../scallop/bash || die
	fi
}

src_compile() {
	local cargoargs=(
		--library-type=cdylib
		--prefix=/usr
		--libdir="/usr/$(get_libdir)"
	)

	# For scallop building bash
	tc-export AR CC

	# Can pass -vv if need more output from e.g. scallop configure
	edo cargo cbuild "${cargoargs[@]}"
}

src_test() {
	if [[ ${PV} == 9999 ]] ; then
		# It's interesting to test the whole thing rather than just
		# pkgcraft-c.
		cd "${WORKDIR}"/${P} || die

		# Need nextest per README (separate processes required)
		# Invocation from https://github.com/pkgcraft/pkgcraft/blob/main/.github/workflows/ci.yml#L56
		edo cargo nextest run --color always --all-features
	else
		# TODO: swap to meson for tests to avoid overtesting
		cargo_src_test
	fi
}

src_install() {
	local cargoargs=(
		--library-type=cdylib
		--prefix=/usr
		--libdir="/usr/$(get_libdir)"
		--destdir="${ED}"
	)

	edo cargo cinstall "${cargoargs[@]}"
}
