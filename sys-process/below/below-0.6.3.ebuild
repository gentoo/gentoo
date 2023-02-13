# Copyright 2022-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
	ahash-0.7.6
	ahash-0.8.0
	aho-corasick-0.7.19
	android_system_properties-0.1.5
	anyhow-1.0.66
	async-trait-0.1.58
	atty-0.2.14
	autocfg-1.1.0
	bitflags-1.3.2
	bumpalo-3.11.1
	bytes-1.2.1
	camino-1.1.1
	cargo-platform-0.1.2
	cargo_metadata-0.14.2
	cc-1.0.73
	cfg-if-1.0.0
	chrono-0.4.22
	clap-3.2.23
	clap_complete-3.2.5
	clap_derive-3.2.18
	clap_lex-0.2.4
	codespan-reporting-0.11.1
	console-0.15.2
	core-foundation-sys-0.8.3
	crossbeam-channel-0.5.6
	crossbeam-deque-0.8.2
	crossbeam-epoch-0.9.11
	crossbeam-utils-0.8.12
	crossterm-0.23.2
	crossterm-0.24.0
	crossterm_winapi-0.9.0
	cursive-0.19.0
	cursive_buffered_backend-0.6.1
	cursive_core-0.3.5
	cxx-1.0.80
	cxx-build-1.0.80
	cxxbridge-flags-1.0.80
	cxxbridge-macro-1.0.80
	darling-0.14.2
	darling_core-0.14.2
	darling_macro-0.14.2
	dirs-next-2.0.0
	dirs-sys-next-0.1.2
	either-1.8.0
	encode_unicode-0.3.6
	enum-map-2.4.1
	enum-map-derive-0.10.0
	enumset-1.0.12
	enumset_derive-0.6.1
	erased-serde-0.3.23
	errno-0.2.8
	errno-dragonfly-0.1.2
	fastrand-1.8.0
	filetime-0.2.18
	fnv-1.0.7
	fuchsia-cprng-0.1.1
	futures-0.1.31
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
	half-1.8.2
	hashbrown-0.12.3
	heck-0.3.3
	heck-0.4.0
	hermit-abi-0.1.19
	hostname-0.3.1
	humantime-2.1.0
	iana-time-zone-0.1.53
	iana-time-zone-haiku-0.1.1
	ident_case-1.0.1
	indexmap-1.9.1
	indicatif-0.17.1
	instant-0.1.12
	io-lifetimes-0.7.4
	itertools-0.10.5
	itoa-1.0.4
	jobserver-0.1.25
	js-sys-0.3.60
	lazy_static-1.4.0
	libbpf-cargo-0.13.1
	libbpf-rs-0.19.1
	libbpf-sys-1.0.4+v1.0.1
	libc-0.2.137
	libm-0.2.5
	link-cplusplus-1.0.7
	linux-raw-sys-0.0.46
	lock_api-0.4.9
	log-0.4.17
	maplit-1.0.2
	match_cfg-0.1.0
	memchr-2.5.0
	memmap-0.7.0
	memmap2-0.5.7
	memoffset-0.6.5
	mio-0.8.5
	nix-0.24.2
	nix-0.25.0
	num-0.4.0
	num-complex-0.4.2
	num-integer-0.1.45
	num-iter-0.1.43
	num-rational-0.4.1
	num-traits-0.2.15
	num_cpus-1.13.1
	num_enum-0.5.7
	num_enum_derive-0.5.7
	num_threads-0.1.6
	number_prefix-0.4.0
	once_cell-1.15.0
	openat-0.1.21
	os_info-3.5.1
	os_str_bytes-6.3.1
	owning_ref-0.4.1
	parking_lot-0.12.1
	parking_lot_core-0.9.4
	paste-1.0.9
	pin-project-lite-0.2.9
	pin-utils-0.1.0
	pkg-config-0.3.26
	plain-0.2.3
	portpicker-0.1.1
	ppv-lite86-0.2.16
	proc-macro-crate-1.2.1
	proc-macro-error-1.0.4
	proc-macro-error-attr-1.0.4
	proc-macro2-1.0.47
	quote-1.0.21
	rand-0.4.6
	rand-0.8.5
	rand_chacha-0.3.1
	rand_core-0.3.1
	rand_core-0.4.2
	rand_core-0.6.4
	rand_distr-0.4.3
	rayon-1.5.3
	rayon-core-1.9.3
	rdrand-0.4.0
	redox_syscall-0.2.16
	redox_users-0.4.3
	regex-1.6.0
	regex-syntax-0.6.27
	remove_dir_all-0.5.3
	rustix-0.35.12
	rustversion-1.0.9
	ryu-1.0.11
	same-file-1.0.6
	scopeguard-1.1.0
	scratch-1.0.2
	scroll-0.11.0
	scroll_derive-0.11.0
	semver-1.0.14
	serde-1.0.147
	serde_cbor-0.11.2
	serde_derive-1.0.147
	serde_json-1.0.87
	signal-hook-0.3.14
	signal-hook-mio-0.2.3
	signal-hook-registry-1.4.0
	slab-0.4.7
	slog-2.7.0
	slog-term-2.9.0
	smallvec-1.10.0
	stable_deref_trait-1.2.0
	static_assertions-1.1.0
	strsim-0.10.0
	strum_macros-0.23.1
	syn-1.0.103
	tar-0.4.38
	tempdir-0.3.7
	tempfile-3.3.0
	term-0.7.0
	termcolor-1.1.3
	terminal_size-0.1.17
	terminal_size-0.2.1
	textwrap-0.16.0
	thiserror-1.0.37
	thiserror-impl-1.0.37
	thread_local-1.1.4
	threadpool-1.8.1
	time-0.3.16
	time-core-0.1.0
	time-macros-0.2.5
	tokio-1.21.2
	toml-0.5.8
	unicase-2.6.0
	unicode-ident-1.0.5
	unicode-segmentation-1.10.0
	unicode-width-0.1.10
	users-0.11.0
	version_check-0.9.4
	vsprintf-2.0.0
	walkdir-2.3.2
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
	windows-sys-0.36.1
	windows-sys-0.42.0
	windows_aarch64_gnullvm-0.42.0
	windows_aarch64_msvc-0.36.1
	windows_aarch64_msvc-0.42.0
	windows_i686_gnu-0.36.1
	windows_i686_gnu-0.42.0
	windows_i686_msvc-0.36.1
	windows_i686_msvc-0.42.0
	windows_x86_64_gnu-0.36.1
	windows_x86_64_gnu-0.42.0
	windows_x86_64_gnullvm-0.42.0
	windows_x86_64_msvc-0.36.1
	windows_x86_64_msvc-0.42.0
	xattr-0.2.3
	xi-unicode-0.3.0
	zstd-0.11.2+zstd.1.5.2
	zstd-safe-5.0.2+zstd.1.5.2
	zstd-sys-2.0.1+zstd.1.5.2
"

inherit cargo systemd

DESCRIPTION="An interactive tool to view and record historical system data"
HOMEPAGE="https://github.com/facebookincubator/below"
SRC_URI="
	https://github.com/facebookincubator/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
	$(cargo_crate_uris)
"
LICENSE="Apache-2.0 Apache-2.0-with-LLVM-exceptions BSD-2 BSD Boost-1.0 ISC LGPL-2.1 MIT MPL-2.0 Unlicense"
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

	systemd_dounit "${FILESDIR}/${PN}.service"
	newinitd "${FILESDIR}/${PN}.initd" below
	newconfd "${FILESDIR}/${PN}.confd" below

	insinto /etc/logrotate.d
	newins "${FILESDIR}/${PN}.logrotated" below
}
