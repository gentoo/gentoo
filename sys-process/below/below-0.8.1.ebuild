# Copyright 2023-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
	addr2line@0.21.0
	adler@1.0.2
	ahash@0.8.0
	aho-corasick@1.0.5
	android_system_properties@0.1.5
	android-tzdata@0.1.1
	anstyle@1.0.1
	anyhow@1.0.80
	anstream@0.6.13
	anstyle@1.0.1
	anstyle-parse@0.2.1
	anstyle-query@1.0.0
	anstyle-wincon@3.0.2
	async-trait@0.1.71
	atty@0.2.14
	autocfg@1.1.0
	backtrace@0.3.69
	bitflags@1.3.2
	bitflags@2.4.0
	bumpalo@3.11.1
	bytes@1.2.1
	camino@1.1.1
	cargo-platform@0.1.2
	cargo_metadata@0.15.4
	cc@1.0.90
	cfg-if@1.0.0
	chrono@0.4.29
	clap@4.5.4
	clap_builder@4.5.2
	clap_complete@4.5.1
	clap_derive@4.5.4
	clap_lex@0.7.0
	codespan-reporting@0.11.1
	colorchoice@1.0.0
	console@0.15.2
	core-foundation-sys@0.8.3
	crossbeam-channel@0.5.6
	crossbeam-deque@0.8.2
	crossbeam-epoch@0.9.11
	crossbeam-utils@0.8.12
	crossterm@0.25.0
	crossterm@0.27.0
	crossterm_winapi@0.9.1
	cursive@0.20.0
	cursive_buffered_backend@0.6.1
	cursive_core@0.3.5
	cxx-build@1.0.80
	cxx@1.0.80
	cxxbridge-flags@1.0.80
	cxxbridge-macro@1.0.80
	darling@0.14.2
	darling_core@0.14.2
	darling_macro@0.14.2
	dirs-next@2.0.0
	dirs-sys-next@0.1.2
	either@1.8.0
	encode_unicode@0.3.6
	enum-iterator@1.4.1
	enum-iterator-derive@1.2.1
	enum-map-derive@0.10.0
	enum-map@2.4.1
	enumset@1.0.12
	enumset_derive@0.6.1
	equivalent@1.0.0
	erased-serde@0.3.23
	errno-dragonfly@0.1.2
	errno@0.2.8
	errno@0.3.1
	fastrand@2.0.1
	filetime@0.2.18
	fnv@1.0.7
	fuchsia-cprng@0.1.1
	futures-channel@0.3.30
	futures-core@0.3.30
	futures-executor@0.3.30
	futures-io@0.3.30
	futures-macro@0.3.30
	futures-sink@0.3.30
	futures-task@0.3.30
	futures-util@0.3.30
	futures@0.1.31
	futures@0.3.30
	getrandom@0.2.8
	gimli@0.28.1
	half@1.8.2
	hashbrown@0.12.3
	hashbrown@0.14.0
	heck@0.4.0
	heck@0.5.0
	hermit-abi@0.1.19
	hermit-abi@0.3.1
	hostname@0.3.1
	humantime@2.1.0
	iana-time-zone-haiku@0.1.1
	iana-time-zone@0.1.53
	ident_case@1.0.1
	indexmap@1.9.1
	indexmap@2.0.0
	indicatif@0.17.6
	instant@0.1.12
	io-lifetimes@0.7.4
	io-lifetimes@1.0.10
	itertools@0.11.0
	itoa@1.0.4
	jobserver@0.1.25
	js-sys@0.3.60
	lazy_static@1.4.0
	libbpf-cargo@0.23.0
	libbpf-rs@0.23.0
	libbpf-sys@1.4.0+v1.4.0
	libc@0.2.153
	libm@0.2.5
	link-cplusplus@1.0.7
	linux-raw-sys@0.4.10
	lock_api@0.4.9
	log@0.4.17
	maplit@1.0.2
	match_cfg@0.1.0
	memchr@2.6.3
	memmap2@0.5.10
	memoffset@0.6.5
	memoffset@0.7.1
	miniz_oxide@0.7.2
	mio@0.8.11
	nix@0.25.0
	nix@0.27.1
	num-complex@0.4.2
	num-integer@0.1.45
	num-iter@0.1.43
	num-rational@0.4.1
	num-traits@0.2.15
	num@0.4.0
	num_cpus@1.16.0
	num_enum@0.5.7
	num_enum_derive@0.5.7
	num_threads@0.1.6
	number_prefix@0.4.0
	object@0.32.2
	once_cell@1.15.0
	openat@0.1.21
	os_info@3.5.1
	os_str_bytes@6.3.1
	owning_ref@0.4.1
	parking_lot@0.12.1
	parking_lot_core@0.9.4
	paste@1.0.14
	pin-project-lite@0.2.13
	pin-utils@0.1.0
	pkg-config@0.3.30
	plain@0.2.3
	portable-atomic@0.3.20
	portable-atomic@1.3.2
	portpicker@0.1.1
	ppv-lite86@0.2.16
	proc-macro-crate@1.2.1
	proc-macro-error-attr@1.0.4
	proc-macro-error@1.0.4
	proc-macro2@1.0.78
	quote@1.0.35
	rand@0.4.6
	rand@0.8.5
	rand_chacha@0.3.1
	rand_core@0.3.1
	rand_core@0.4.2
	rand_core@0.6.4
	rand_distr@0.4.3
	rayon-core@1.9.3
	rayon@1.5.3
	rdrand@0.4.0
	redox_syscall@0.2.16
	redox_syscall@0.4.1
	redox_users@0.4.3
	regex-automata@0.3.8
	regex-syntax@0.7.5
	regex@1.9.5
	remove_dir_all@0.5.3
	rustc-demangle@0.1.23
	rustix@0.35.12
	rustix@0.38.21
	rustversion@1.0.9
	ryu@1.0.11
	same-file@1.0.6
	scopeguard@1.1.0
	scratch@1.0.2
	scroll@0.11.0
	scroll_derive@0.11.0
	semver@1.0.14
	serde@1.0.188
	serde_cbor@0.11.2
	serde_derive@1.0.188
	serde_json@1.0.100
	serde_spanned@0.6.4
	signal-hook-mio@0.2.3
	signal-hook-registry@1.4.0
	signal-hook@0.3.17
	slab@0.4.7
	slog-term@2.9.0
	slog@2.7.0
	socket2@0.5.6
	smallvec@1.10.0
	stable_deref_trait@1.2.0
	static_assertions@1.1.0
	strsim@0.11.0
	strum_macros@0.24.3
	syn@1.0.109
	syn@2.0.52
	tar@0.4.40
	tempdir@0.3.7
	tempfile@3.8.1
	term@0.7.0
	termcolor@1.1.3
	terminal_size@0.1.17
	terminal_size@0.3.0
	textwrap@0.16.0
	thiserror-impl@1.0.57
	thiserror@1.0.57
	thread_local@1.1.4
	threadpool@1.8.1
	time-core@0.1.0
	time-macros@0.2.5
	time@0.3.16
	tokio@1.37.0
	tokio-macros@2.2.0
	toml@0.5.8
	toml@0.8.6
	toml_datetime@0.6.5
	toml_edit@0.20.7
	tracing@0.1.40
	tracing-core@0.1.32
	unicase@2.6.0
	unicode-ident@1.0.5
	unicode-segmentation@1.10.0
	unicode-width@0.1.10
	utf8parse@0.2.1
	uzers@0.11.3
	version_check@0.9.4
	vsprintf@2.0.0
	walkdir@2.3.2
	wasi@0.11.0+wasi-snapshot-preview1
	wasm-bindgen-backend@0.2.83
	wasm-bindgen-macro-support@0.2.83
	wasm-bindgen-macro@0.2.83
	wasm-bindgen-shared@0.2.83
	wasm-bindgen@0.2.83
	winapi-i686-pc-windows-gnu@0.4.0
	winapi-util@0.1.5
	winapi-x86_64-pc-windows-gnu@0.4.0
	winapi@0.3.9
	windows-sys@0.36.1
	windows-sys@0.42.0
	windows-sys@0.45.0
	windows-sys@0.48.0
	windows-sys@0.52.0
	windows-targets@0.42.2
	windows-targets@0.48.0
	windows-targets@0.52.4
	windows_aarch64_gnullvm@0.42.2
	windows_aarch64_gnullvm@0.48.0
	windows_aarch64_gnullvm@0.52.4
	windows_aarch64_msvc@0.36.1
	windows_aarch64_msvc@0.42.2
	windows_aarch64_msvc@0.48.0
	windows_aarch64_msvc@0.52.4
	windows_i686_gnu@0.36.1
	windows_i686_gnu@0.42.2
	windows_i686_gnu@0.48.0
	windows_i686_gnu@0.52.4
	windows_i686_msvc@0.36.1
	windows_i686_msvc@0.42.2
	windows_i686_msvc@0.48.0
	windows_i686_msvc@0.52.4
	windows_x86_64_gnu@0.36.1
	windows_x86_64_gnu@0.42.2
	windows_x86_64_gnu@0.48.0
	windows_x86_64_gnu@0.52.4
	windows_x86_64_gnullvm@0.42.2
	windows_x86_64_gnullvm@0.48.0
	windows_x86_64_gnullvm@0.52.4
	windows_x86_64_msvc@0.36.1
	windows_x86_64_msvc@0.42.2
	windows_x86_64_msvc@0.48.0
	windows_x86_64_msvc@0.52.4
	winnow@0.5.18
	xattr@1.0.1
	xi-unicode@0.3.0
	zstd-safe@7.0.0
	zstd-sys@2.0.9+zstd.1.5.5
	zstd@0.13.0
"

inherit cargo systemd

DESCRIPTION="An interactive tool to view and record historical system data"
HOMEPAGE="https://github.com/facebookincubator/below"
SRC_URI="
	https://github.com/facebookincubator/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
	${CARGO_CRATE_URIS}
"

LICENSE="Apache-2.0"
# Dependent crate licenses
LICENSE+=" BSD-2 BSD ISC MIT Unicode-DFS-2016 Unlicense"

SLOT="0"
KEYWORDS="amd64 ~ppc64"

BDEPEND="
	sys-devel/clang
	virtual/pkgconfig
	>=virtual/rust-1.56[rustfmt]
"
RDEPEND="
	virtual/libelf
	sys-libs/zlib
"
DEPEND="
	${RDEPEND}
	sys-libs/ncurses
"

QA_FLAGS_IGNORED="usr/bin/below"

src_test() {
	local skip=(
		--skip disable_disk_stat
		--skip advance_forward_and_reverse
		--skip disable_io_stat
		--skip record_replay_integration
		--skip test_belowrc_to_event
	)
	cargo_src_test --workspace below -- "${skip[@]}"
}

src_install() {
	cargo_src_install --path below

	keepdir /var/log/below

	systemd_dounit "etc/${PN}.service"
	newinitd "${FILESDIR}/${PN}-r1.initd" below
	newconfd "${FILESDIR}/${PN}.confd" below

	insinto /etc/logrotate.d
	newins etc/logrotate.conf below

	dodoc -r docs
}
