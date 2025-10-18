# Copyright 2023-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
	addr2line@0.24.2
	adler2@2.0.0
	ahash@0.8.11
	aho-corasick@1.1.3
	android_system_properties@0.1.5
	anstream@0.6.18
	anstyle-parse@0.2.6
	anstyle-query@1.1.2
	anstyle-wincon@3.0.7
	anstyle@1.0.10
	anyhow@1.0.100
	async-trait@0.1.88
	autocfg@1.4.0
	backtrace@0.3.74
	base64@0.22.1
	bitflags@2.9.0
	bumpalo@3.17.0
	bytes@1.10.1
	camino@1.1.9
	cargo-platform@0.1.9
	cargo_metadata@0.19.2
	castaway@0.2.4
	cc@1.2.17
	cfg-if@1.0.0
	cfg_aliases@0.2.1
	chrono@0.4.42
	clap@4.5.48
	clap_builder@4.5.48
	clap_complete@4.5.58
	clap_derive@4.5.47
	clap_lex@0.7.4
	colorchoice@1.0.3
	compact_str@0.8.1
	console@0.15.11
	core-foundation-sys@0.8.7
	crossbeam-channel@0.5.14
	crossbeam-deque@0.8.6
	crossbeam-epoch@0.9.18
	crossbeam-utils@0.8.21
	crossterm@0.28.1
	crossterm_winapi@0.9.1
	cursive-macros@0.1.0
	cursive@0.21.1
	cursive_core@0.4.6
	darling@0.20.10
	darling_core@0.20.10
	darling_macro@0.20.10
	deranged@0.4.1
	dirs-next@2.0.0
	dirs-sys-next@0.1.2
	either@1.15.0
	encode_unicode@1.0.0
	enum-iterator-derive@1.5.0
	enum-iterator@2.3.0
	enum-map-derive@0.17.0
	enum-map@2.7.3
	enumset@1.1.5
	enumset_derive@0.10.0
	equivalent@1.0.2
	erased-serde@0.3.31
	errno@0.3.10
	fastrand@2.3.0
	filetime@0.2.25
	fnv@1.0.7
	futures-channel@0.3.31
	futures-core@0.3.31
	futures-executor@0.3.31
	futures-io@0.3.31
	futures-macro@0.3.31
	futures-sink@0.3.31
	futures-task@0.3.31
	futures-util@0.3.31
	futures@0.1.31
	futures@0.3.31
	getrandom@0.2.15
	getrandom@0.3.2
	gimli@0.31.1
	half@1.8.3
	hashbrown@0.15.2
	heck@0.5.0
	hermit-abi@0.3.9
	hermit-abi@0.5.0
	hostname@0.3.1
	humantime@2.2.0
	iana-time-zone-haiku@0.1.2
	iana-time-zone@0.1.62
	ident_case@1.0.1
	indexmap@2.11.4
	indicatif@0.17.11
	io-uring@0.7.10
	is-terminal@0.4.16
	is_terminal_polyfill@1.70.1
	itertools@0.14.0
	itoa@1.0.15
	jobserver@0.1.32
	js-sys@0.3.77
	lazy_static@1.5.0
	libbpf-cargo@0.26.0-beta.0
	libbpf-rs@0.26.0-beta.0
	libbpf-sys@1.5.0+v1.5.0
	libc@0.2.175
	libm@0.2.11
	libredox@0.1.3
	linux-raw-sys@0.4.15
	linux-raw-sys@0.9.3
	lock_api@0.4.12
	log@0.4.27
	maplit@1.0.2
	match_cfg@0.1.0
	memchr@2.7.4
	memmap2@0.9.8
	memoffset@0.9.1
	miniz_oxide@0.8.5
	mio@1.0.3
	netlink-packet-core@0.8.1
	netlink-packet-route@0.25.1
	netlink-sys@0.8.7
	nix@0.29.0
	nix@0.30.1
	nu-ansi-term@0.50.1
	num-complex@0.4.6
	num-conv@0.1.0
	num-integer@0.1.46
	num-iter@0.1.45
	num-rational@0.4.2
	num-traits@0.2.19
	num@0.4.3
	num_cpus@1.16.0
	num_threads@0.1.7
	number_prefix@0.4.0
	object@0.36.7
	once_cell@1.21.1
	openat@0.1.21
	os_info@3.12.0
	parking_lot@0.12.3
	parking_lot_core@0.9.10
	paste@1.0.15
	pin-project-lite@0.2.16
	pin-utils@0.1.0
	pkg-config@0.3.32
	plain@0.2.3
	plist@1.8.0
	portable-atomic@1.11.0
	portpicker@0.1.1
	powerfmt@0.2.0
	ppv-lite86@0.2.21
	proc-macro2@1.0.94
	quick-xml@0.38.3
	quote@1.0.40
	r-efi@5.2.0
	rand@0.8.5
	rand_chacha@0.3.1
	rand_core@0.6.4
	rand_distr@0.4.3
	rayon-core@1.12.1
	rayon@1.10.0
	redox_syscall@0.5.10
	redox_users@0.4.6
	regex-automata@0.4.9
	regex-syntax@0.8.5
	regex@1.11.1
	rustc-demangle@0.1.24
	rustix@0.38.44
	rustix@1.0.3
	rustversion@1.0.20
	ryu@1.0.20
	same-file@1.0.6
	scopeguard@1.2.0
	semver@1.0.26
	serde@1.0.226
	serde_cbor@0.11.2
	serde_core@1.0.226
	serde_derive@1.0.226
	serde_json@1.0.140
	serde_spanned@1.0.2
	sharded-slab@0.1.7
	shlex@1.3.0
	signal-hook-mio@0.2.4
	signal-hook-registry@1.4.2
	signal-hook@0.3.17
	slab@0.4.9
	slog-term@2.9.1
	slog@2.7.0
	smallvec@1.14.0
	socket2@0.6.0
	static_assertions@1.1.0
	strsim@0.11.1
	syn@1.0.109
	syn@2.0.100
	tar@0.4.44
	tempfile@3.22.0
	term@0.7.0
	terminal_size@0.4.2
	thiserror-impl@1.0.69
	thiserror-impl@2.0.12
	thiserror@1.0.69
	thiserror@2.0.12
	thread_local@1.1.8
	threadpool@1.8.1
	time-core@0.1.4
	time-macros@0.2.22
	time@0.3.41
	tokio-macros@2.5.0
	tokio@1.47.1
	toml@0.9.7
	toml_datetime@0.7.2
	toml_parser@1.0.3
	toml_writer@1.0.3
	tracing-core@0.1.33
	tracing-subscriber@0.3.20
	tracing@0.1.41
	unicase@2.8.1
	unicode-ident@1.0.18
	unicode-segmentation@1.12.0
	unicode-width@0.1.14
	unicode-width@0.2.0
	utf8parse@0.2.2
	version_check@0.9.5
	vsprintf@2.0.0
	walkdir@2.5.0
	wasi@0.11.0+wasi-snapshot-preview1
	wasi@0.14.2+wasi-0.2.4
	wasm-bindgen-backend@0.2.100
	wasm-bindgen-macro-support@0.2.100
	wasm-bindgen-macro@0.2.100
	wasm-bindgen-shared@0.2.100
	wasm-bindgen@0.2.100
	web-time@1.1.0
	winapi-i686-pc-windows-gnu@0.4.0
	winapi-util@0.1.9
	winapi-x86_64-pc-windows-gnu@0.4.0
	winapi@0.3.9
	windows-core@0.52.0
	windows-link@0.2.0
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
	winnow@0.7.13
	wit-bindgen-rt@0.39.0
	xattr@1.5.0
	xi-unicode@0.3.0
	zerocopy-derive@0.7.35
	zerocopy-derive@0.8.24
	zerocopy@0.7.35
	zerocopy@0.8.24
	zstd-safe@7.2.4
	zstd-sys@2.0.15+zstd.1.5.7
	zstd@0.13.3
"

RUST_MIN_VER="1.85.0"
RUST_REQ_USE="rustfmt"

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
KEYWORDS="~amd64 ~ppc64"

BDEPEND="
	llvm-core/clang
	virtual/pkgconfig
"
RDEPEND="
	app-arch/zstd:=
	sys-libs/zlib
	virtual/libelf:=
"
DEPEND="
	${RDEPEND}
	sys-libs/ncurses
"

QA_FLAGS_IGNORED="usr/bin/below"

src_configure() {
	export ZSTD_SYS_USE_PKG_CONFIG=1

	cargo_src_configure
}

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
