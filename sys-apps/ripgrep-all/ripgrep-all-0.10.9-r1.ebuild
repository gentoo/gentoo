# Copyright 2024-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
	addr2line@0.24.2
	adler2@2.0.0
	ahash@0.8.11
	aho-corasick@1.1.3
	alloc-no-stdlib@2.0.4
	alloc-stdlib@0.2.2
	allocator-api2@0.2.21
	android-tzdata@0.1.1
	android_system_properties@0.1.5
	ansi_term@0.12.1
	anstream@0.6.18
	anstyle-parse@0.2.6
	anstyle-query@1.1.2
	anstyle-wincon@3.0.7
	anstyle@1.0.10
	anyhow@1.0.96
	astral-tokio-tar@0.5.1
	async-compression@0.3.15
	async-compression@0.4.19
	async-recursion@1.1.1
	async-stream-impl@0.3.6
	async-stream@0.3.6
	async-trait@0.1.86
	async_zip@0.0.12
	atty@0.2.14
	autocfg@1.4.0
	backtrace@0.3.74
	base64@0.22.1
	bincode@1.3.3
	bitflags@1.3.2
	bitflags@2.9.0
	brotli-decompressor@4.0.2
	brotli@7.0.0
	bumpalo@3.17.0
	bytes@1.10.0
	bzip2-sys@0.1.13+1.0.8
	bzip2@0.4.4
	bzip2@0.5.2
	cc@1.2.16
	cfg-if@1.0.0
	charset@0.1.5
	chrono@0.4.40
	clap@2.34.0
	clap@4.5.31
	clap_builder@4.5.31
	clap_lex@0.7.4
	colorchoice@1.0.3
	convert_case@0.4.0
	core-foundation-sys@0.8.7
	crc32fast@1.4.2
	crossbeam-channel@0.5.14
	crossbeam-deque@0.8.6
	crossbeam-epoch@0.9.18
	crossbeam-queue@0.3.12
	crossbeam-utils@0.8.21
	crossbeam@0.8.4
	ctor@0.2.9
	data-encoding@2.8.0
	deflate64@0.1.9
	derive_more@0.99.19
	diff@0.1.13
	directories-next@2.0.0
	dirs-sys-next@0.1.2
	dyn-clonable-impl@0.9.2
	dyn-clonable@0.9.2
	dyn-clone@1.0.18
	encoding_rs@0.8.35
	encoding_rs_io@0.1.7
	env_logger@0.10.2
	equivalent@1.0.2
	errno@0.3.10
	fallible-iterator@0.3.0
	fallible-streaming-iterator@0.1.9
	fastrand@2.3.0
	filetime@0.2.25
	fixedbitset@0.4.2
	flate2@1.1.0
	fnv@1.0.7
	futures-core@0.3.31
	futures-io@0.3.31
	futures-macro@0.3.31
	futures-sink@0.3.31
	futures-task@0.3.31
	futures-util@0.3.31
	generic-array@0.12.4
	getopts@0.2.21
	getrandom@0.2.15
	getrandom@0.3.1
	gimli@0.31.1
	glob@0.3.2
	hashbrown@0.12.3
	hashbrown@0.14.5
	hashbrown@0.15.2
	hashlink@0.8.4
	heck@0.3.3
	hermit-abi@0.1.19
	hermit-abi@0.4.0
	humantime@2.1.0
	iana-time-zone-haiku@0.1.2
	iana-time-zone@0.1.61
	indexmap@1.9.3
	indexmap@2.7.1
	is-docker@0.2.0
	is-terminal@0.4.15
	is-wsl@0.4.0
	is_terminal_polyfill@1.70.1
	itoa@1.0.14
	jobserver@0.1.32
	js-sys@0.3.77
	json_comments@0.2.2
	lazy_static@1.5.0
	libc@0.2.170
	libredox@0.1.3
	libsqlite3-sys@0.27.0
	linux-raw-sys@0.4.15
	lock_api@0.4.12
	log@0.4.26
	lzma-sys@0.1.20
	mailparse@0.14.1
	memchr@2.7.4
	mime2ext@0.1.53
	minimal-lexical@0.2.1
	miniz_oxide@0.8.5
	mio@1.0.3
	nom@7.1.3
	num-complex@0.2.4
	num-integer@0.1.46
	num-iter@0.1.45
	num-rational@0.2.4
	num-traits@0.2.19
	num@0.2.1
	object@0.36.7
	once_cell@1.20.3
	open@5.3.2
	parking_lot@0.12.3
	parking_lot_core@0.9.10
	paste@1.0.15
	path-clean@1.0.1
	pathdiff@0.2.3
	petgraph@0.6.5
	pin-project-internal@1.1.9
	pin-project-lite@0.2.16
	pin-project@1.1.9
	pin-utils@0.1.0
	pkg-config@0.3.31
	portable-atomic@1.11.0
	pretty-bytes@0.2.2
	pretty_assertions@1.4.1
	proc-macro-error-attr@1.0.4
	proc-macro-error@1.0.4
	proc-macro2@1.0.93
	quote@1.0.38
	quoted_printable@0.5.1
	redox_syscall@0.5.9
	redox_users@0.4.6
	regex-automata@0.4.9
	regex-syntax@0.8.5
	regex@1.11.1
	rusqlite@0.30.0
	rustc-demangle@0.1.24
	rustc-hash@2.1.1
	rustc_version@0.4.1
	rustix@0.38.44
	rustversion@1.0.19
	ryu@1.0.19
	schemars@0.8.22
	schemars_derive@0.8.22
	scopeguard@1.2.0
	semver@1.0.25
	serde@1.0.218
	serde_derive@1.0.218
	serde_derive_internals@0.29.1
	serde_json@1.0.139
	shlex@1.3.0
	signal-hook-registry@1.4.2
	size_format@1.0.2
	slab@0.4.9
	smallvec@1.14.0
	socket2@0.5.8
	strsim@0.11.1
	strsim@0.8.0
	structopt-derive@0.4.18
	structopt@0.3.26
	syn@1.0.109
	syn@2.0.98
	tempfile@3.17.1
	termcolor@1.4.1
	terminal_size@0.4.1
	textwrap@0.11.0
	thiserror-impl@1.0.69
	thiserror@1.0.69
	tokio-macros@2.5.0
	tokio-rusqlite@0.5.0
	tokio-stream@0.1.17
	tokio-test@0.4.4
	tokio-util@0.7.13
	tokio@1.43.0
	tree_magic_mini@3.1.6
	typenum@1.18.0
	unicode-ident@1.0.17
	unicode-segmentation@1.12.0
	unicode-width@0.1.14
	utf8parse@0.2.2
	vcpkg@0.2.15
	vec_map@0.8.2
	version_check@0.9.5
	wasi@0.11.0+wasi-snapshot-preview1
	wasi@0.13.3+wasi-0.2.2
	wasm-bindgen-backend@0.2.100
	wasm-bindgen-macro-support@0.2.100
	wasm-bindgen-macro@0.2.100
	wasm-bindgen-shared@0.2.100
	wasm-bindgen@0.2.100
	winapi-i686-pc-windows-gnu@0.4.0
	winapi-util@0.1.9
	winapi-x86_64-pc-windows-gnu@0.4.0
	winapi@0.3.9
	windows-core@0.52.0
	windows-link@0.1.0
	windows-sys@0.52.0
	windows-sys@0.59.0
	windows-targets@0.52.6
	windows_aarch64_gnullvm@0.52.6
	windows_aarch64_msvc@0.52.6
	windows_i686_gnu@0.52.6
	windows_i686_gnullvm@0.52.6
	windows_i686_msvc@0.52.6
	windows_x86_64_gnu@0.52.6
	windows_x86_64_gnullvm@0.52.6
	windows_x86_64_msvc@0.52.6
	wit-bindgen-rt@0.33.0
	xattr@1.4.0
	xz2@0.1.7
	yansi@1.0.1
	zerocopy-derive@0.7.35
	zerocopy@0.7.35
	zstd-safe@5.0.2+zstd.1.5.2
	zstd-safe@7.2.3
	zstd-sys@2.0.14+zstd.1.5.7
	zstd@0.11.2+zstd.1.5.2
	zstd@0.13.3
"

RUST_MIN_VER="1.85.0"

inherit cargo optfeature

DESCRIPTION="Like ripgrep, but also search in PDFs, E-Books, Office documents, archives, etc."
HOMEPAGE="https://github.com/phiresky/ripgrep-all"
SRC_URI="
	https://github.com/phiresky/ripgrep-all/archive/v${PV}.tar.gz -> ${P}.tar.gz
	${CARGO_CRATE_URIS}
"

LICENSE="AGPL-3+"
# Dependent crate licenses
LICENSE+=" 0BSD Apache-2.0 BSD MIT Unicode-3.0"
SLOT="0"
KEYWORDS="~amd64"

IUSE="test"
RESTRICT="!test? ( test )"

COMMON_DEPEND="
	app-arch/xz-utils
	sys-apps/ripgrep
"
RDEPEND="
	${COMMON_DEPEND}
	app-arch/zstd:=
	dev-db/sqlite:3
	app-arch/bzip2:=
"
DEPEND="
	${COMMON_DEPEND}
	test? (
		app-text/poppler
		virtual/pandoc
	)
"

QA_FLAGS_IGNORED="
	usr/bin/rga
	usr/bin/rga-fzf
	usr/bin/rga-fzf-open
	usr/bin/rga-preproc
"

src_configure() {
	export ZSTD_SYS_USE_PKG_CONFIG=1
	export LIBSQLITE3_SYS_USE_PKG_CONFIG=1

	# bzip2-sys requires a pkg-config file
	# https://github.com/alexcrichton/bzip2-rs/issues/104
	mkdir "${T}/pkg-config" || die
	export PKG_CONFIG_PATH=${T}/pkg-config${PKG_CONFIG_PATH+:${PKG_CONFIG_PATH}}
	cat >> "${T}/pkg-config/bzip2.pc" <<-EOF || die
		Name: bzip2
		Version: 9999
		Description:
		Libs: -lbz2
	EOF

	cargo_src_configure
}

pkg_postinst() {
	optfeature "pandoc support" virtual/pandoc
	optfeature "pdf support" app-text/poppler
	optfeature "media support" media-video/ffmpeg
}
