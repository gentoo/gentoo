# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
	ahash-0.7.6
	aho-corasick-0.7.20
	annotate-snippets-0.6.1
	async-trait-0.1.62
	async_once-0.2.6
	autocfg-1.1.0
	autotools-0.2.5
	bindgen-0.63.0
	bitflags-1.3.2
	cached-0.42.0
	cached_proc_macro-0.16.0
	cached_proc_macro_types-0.1.0
	camino-1.1.2
	cc-1.0.78
	cexpr-0.6.0
	cfg-if-1.0.0
	chic-1.2.2
	clang-sys-1.4.0
	clap-4.1.1
	clap_derive-4.1.0
	clap_lex-0.3.1
	crossbeam-channel-0.5.6
	crossbeam-utils-0.8.14
	ctor-0.1.26
	darling-0.14.2
	darling_core-0.14.2
	darling_macro-0.14.2
	dlv-list-0.3.0
	either-1.8.0
	enum-as-inner-0.5.1
	errno-0.2.8
	errno-dragonfly-0.1.2
	fastrand-1.8.0
	filetime-0.2.19
	fnv-1.0.7
	futures-0.3.25
	futures-channel-0.3.25
	futures-core-0.3.25
	futures-executor-0.3.25
	futures-io-0.3.25
	futures-macro-0.3.25
	futures-sink-0.3.25
	futures-task-0.3.25
	futures-util-0.3.25
	getrandom-0.2.8
	glob-0.3.1
	hashbrown-0.12.3
	hashbrown-0.13.2
	heck-0.4.0
	hermit-abi-0.2.6
	ident_case-1.0.1
	indexmap-1.9.2
	indoc-1.0.8
	instant-0.1.12
	io-lifetimes-1.0.4
	is-terminal-0.4.2
	is_executable-1.0.1
	itertools-0.10.5
	lazy_static-1.4.0
	lazycell-1.3.0
	libc-0.2.139
	libloading-0.7.4
	linux-raw-sys-0.1.4
	log-0.4.17
	memchr-2.5.0
	memoffset-0.7.1
	minimal-lexical-0.2.1
	nix-0.26.2
	nom-7.1.3
	nu-ansi-term-0.46.0
	num_cpus-1.15.0
	once_cell-1.17.0
	ordered-multimap-0.4.3
	os_str_bytes-6.4.1
	overload-0.1.1
	peeking_take_while-0.1.2
	peg-0.8.1
	peg-macros-0.8.1
	peg-runtime-0.8.1
	pin-project-lite-0.2.9
	pin-utils-0.1.0
	pkgcraft-0.0.4
	proc-macro-error-1.0.4
	proc-macro-error-attr-1.0.4
	proc-macro2-1.0.50
	quote-1.0.23
	redox_syscall-0.2.16
	regex-1.7.1
	regex-syntax-0.6.28
	remove_dir_all-0.5.3
	roxmltree-0.17.0
	rust-ini-0.18.0
	rustc-hash-1.1.0
	rustix-0.36.7
	rustversion-1.0.11
	same-file-1.0.6
	scallop-0.0.3
	serde-1.0.152
	serde_derive-1.0.152
	serde_with-2.2.0
	serde_with_macros-2.2.0
	sharded-slab-0.1.4
	shlex-1.1.0
	slab-0.4.7
	smallvec-1.10.0
	static_assertions-1.1.0
	strsim-0.10.0
	strum-0.24.1
	strum_macros-0.24.3
	syn-1.0.107
	sys-info-0.9.1
	tempfile-3.3.0
	termcolor-1.2.0
	thiserror-1.0.38
	thiserror-impl-1.0.38
	thread_local-1.1.4
	tokio-1.24.2
	tokio-macros-1.8.2
	toml-0.5.11
	tracing-0.1.37
	tracing-attributes-0.1.23
	tracing-core-0.1.30
	tracing-log-0.1.3
	tracing-subscriber-0.3.16
	unicode-ident-1.0.6
	valuable-0.1.0
	version_check-0.9.4
	walkdir-2.3.2
	wasi-0.11.0+wasi-snapshot-preview1
	which-4.4.0
	winapi-0.3.9
	winapi-i686-pc-windows-gnu-0.4.0
	winapi-util-0.1.5
	winapi-x86_64-pc-windows-gnu-0.4.0
	windows-sys-0.42.0
	windows_aarch64_gnullvm-0.42.1
	windows_aarch64_msvc-0.42.1
	windows_i686_gnu-0.42.1
	windows_i686_msvc-0.42.1
	windows_x86_64_gnu-0.42.1
	windows_x86_64_gnullvm-0.42.1
	windows_x86_64_msvc-0.42.1
	xmlparser-0.13.5
"
CRATES+="
	pkgcraft-c-${PV}
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
	SRC_URI="$(cargo_crate_uris)"
	S="${WORKDIR}"/cargo_home/gentoo/pkgcraft-c-${PV}

	KEYWORDS="~amd64"
fi

LICENSE="MIT"
# Dependent crate licenses
LICENSE+=" Apache-2.0 BSD GPL-3+ ISC MIT Unicode-DFS-2016"
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
