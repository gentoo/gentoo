# Copyright 2024-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LLVM_COMPAT=( {16..19} )

# List of crates for pycargoebuild:
# rust/scx_{loader,rustland_core,stats,utils}
# scheds/rust/scx_{bpfland,lavd,layered,rlfifo,rustland,rusty}
CRATES="
	addr2line@0.24.1
	adler2@2.0.0
	aho-corasick@1.1.3
	android-tzdata@0.1.1
	android_system_properties@0.1.5
	anstream@0.6.15
	anstyle-parse@0.2.5
	anstyle-query@1.1.1
	anstyle-wincon@3.0.4
	anstyle@1.0.8
	anyhow@1.0.87
	async-broadcast@0.7.1
	async-channel@2.3.1
	async-executor@1.13.1
	async-fs@2.1.2
	async-io@2.3.4
	async-lock@3.4.0
	async-process@2.2.4
	async-recursion@1.1.1
	async-signal@0.2.10
	async-task@4.7.1
	async-trait@0.1.82
	atomic-waker@1.1.2
	autocfg@1.3.0
	backtrace@0.3.74
	bindgen@0.69.4
	bitflags@1.3.2
	bitflags@2.6.0
	bitvec@1.0.1
	blocking@1.6.1
	bumpalo@3.16.0
	bytes@1.7.1
	camino@1.1.9
	cargo-platform@0.1.8
	cargo_metadata@0.15.4
	cargo_metadata@0.18.1
	cc@1.1.18
	cexpr@0.6.0
	cfg-if@1.0.0
	cfg_aliases@0.2.1
	cgroupfs@0.7.1
	chrono@0.4.38
	clang-sys@1.8.1
	clap@4.5.17
	clap_builder@4.5.17
	clap_derive@4.5.13
	clap_lex@0.7.2
	colorchoice@1.0.2
	colored@2.1.0
	concurrent-queue@2.5.0
	const_format@0.2.31
	const_format_proc_macros@0.2.31
	convert_case@0.6.0
	core-foundation-sys@0.8.7
	crossbeam-channel@0.5.13
	crossbeam-deque@0.8.5
	crossbeam-epoch@0.9.18
	crossbeam-queue@0.3.11
	crossbeam-utils@0.8.20
	crossbeam@0.8.4
	ctrlc@3.4.5
	darling@0.20.10
	darling_core@0.20.10
	darling_macro@0.20.10
	deranged@0.3.11
	either@1.13.0
	endi@1.1.0
	enumflags2@0.7.10
	enumflags2_derive@0.7.10
	equivalent@1.0.1
	errno@0.3.9
	event-listener-strategy@0.5.2
	event-listener@5.3.1
	fastrand@2.1.1
	fb_procfs@0.7.1
	filetime@0.2.25
	fnv@1.0.7
	funty@2.0.0
	futures-core@0.3.30
	futures-io@0.3.30
	futures-lite@2.3.0
	futures-sink@0.3.30
	futures-task@0.3.30
	futures-util@0.3.30
	gimli@0.31.0
	glob@0.3.1
	gpoint@0.2.1
	hashbrown@0.14.5
	heck@0.5.0
	hermit-abi@0.3.9
	hermit-abi@0.4.0
	hex@0.4.3
	home@0.5.9
	iana-time-zone-haiku@0.1.2
	iana-time-zone@0.1.60
	ident_case@1.0.1
	indexmap@2.5.0
	is_terminal_polyfill@1.70.1
	itertools@0.12.1
	itertools@0.13.0
	itoa@1.0.11
	js-sys@0.3.70
	lazy_static@1.5.0
	lazycell@1.3.0
	libbpf-cargo@0.24.8
	libbpf-rs@0.24.8
	libbpf-sys@1.4.6+v1.4.7
	libc@0.2.158
	libloading@0.8.5
	libredox@0.1.3
	linux-raw-sys@0.4.14
	log@0.4.22
	maplit@1.0.2
	memchr@2.7.4
	memmap2@0.5.10
	memoffset@0.6.5
	memoffset@0.9.1
	minimal-lexical@0.2.1
	miniz_oxide@0.8.0
	mio@1.0.2
	nix@0.25.1
	nix@0.29.0
	nom@7.1.3
	ntapi@0.4.1
	num-conv@0.1.0
	num-traits@0.2.19
	num_cpus@1.16.0
	num_threads@0.1.7
	nvml-wrapper-sys@0.8.0
	nvml-wrapper@0.10.0
	object@0.36.4
	once_cell@1.19.0
	openat@0.1.21
	ordered-float@3.9.2
	ordered-stream@0.2.0
	parking@2.2.1
	paste@1.0.15
	pin-project-lite@0.2.14
	pin-utils@0.1.0
	piper@0.2.4
	pkg-config@0.3.30
	plain@0.2.3
	polling@3.7.3
	powerfmt@0.2.0
	prettyplease@0.2.22
	proc-macro-crate@3.2.0
	proc-macro2@1.0.86
	quote@1.0.37
	radium@0.7.0
	rayon-core@1.12.1
	rayon@1.10.0
	redox_syscall@0.5.3
	regex-automata@0.4.7
	regex-syntax@0.6.29
	regex-syntax@0.8.4
	regex@1.10.6
	rustc-demangle@0.1.24
	rustc-hash@1.1.0
	rustix@0.38.36
	rustversion@1.0.17
	ryu@1.0.18
	same-file@1.0.6
	semver@1.0.23
	serde@1.0.210
	serde_derive@1.0.210
	serde_json@1.0.128
	serde_repr@0.1.19
	serde_spanned@0.6.8
	shlex@1.3.0
	signal-hook-registry@1.4.2
	simple_logger@5.0.0
	simplelog@0.12.2
	slab@0.4.9
	socket2@0.5.7
	sorted-vec@0.8.3
	sscanf@0.4.2
	sscanf_macro@0.4.2
	static_assertions@1.1.0
	strsim@0.10.0
	strsim@0.11.1
	syn@2.0.77
	sysinfo@0.31.4
	tap@1.0.1
	tar@0.4.41
	tempfile@3.12.0
	termcolor@1.4.1
	terminal_size@0.3.0
	thiserror-impl@1.0.63
	thiserror@1.0.63
	threadpool@1.8.1
	time-core@0.1.2
	time-macros@0.2.18
	time@0.3.36
	tokio-macros@2.4.0
	tokio@1.40.0
	toml@0.8.19
	toml_datetime@0.6.8
	toml_edit@0.22.20
	tracing-attributes@0.1.27
	tracing-core@0.1.32
	tracing@0.1.40
	uds_windows@1.1.0
	unicase@2.7.0
	unicode-ident@1.0.12
	unicode-segmentation@1.11.0
	unicode-width@0.1.12
	unicode-xid@0.2.5
	utf8parse@0.2.2
	vergen@8.3.2
	version-compare@0.1.1
	version_check@0.9.5
	vsprintf@2.0.0
	walkdir@2.5.0
	wasi@0.11.0+wasi-snapshot-preview1
	wasm-bindgen-backend@0.2.93
	wasm-bindgen-macro-support@0.2.93
	wasm-bindgen-macro@0.2.93
	wasm-bindgen-shared@0.2.93
	wasm-bindgen@0.2.93
	which@4.4.2
	winapi-i686-pc-windows-gnu@0.4.0
	winapi-util@0.1.9
	winapi-x86_64-pc-windows-gnu@0.4.0
	winapi@0.3.9
	windows-core@0.52.0
	windows-core@0.57.0
	windows-implement@0.57.0
	windows-interface@0.57.0
	windows-result@0.1.2
	windows-sys@0.48.0
	windows-sys@0.52.0
	windows-sys@0.59.0
	windows-targets@0.48.5
	windows-targets@0.52.6
	windows@0.57.0
	windows_aarch64_gnullvm@0.48.5
	windows_aarch64_gnullvm@0.52.6
	windows_aarch64_msvc@0.48.5
	windows_aarch64_msvc@0.52.6
	windows_i686_gnu@0.48.5
	windows_i686_gnu@0.52.6
	windows_i686_gnullvm@0.52.6
	windows_i686_msvc@0.48.5
	windows_i686_msvc@0.52.6
	windows_x86_64_gnu@0.48.5
	windows_x86_64_gnu@0.52.6
	windows_x86_64_gnullvm@0.48.5
	windows_x86_64_gnullvm@0.52.6
	windows_x86_64_msvc@0.48.5
	windows_x86_64_msvc@0.52.6
	winnow@0.6.18
	wrapcenum-derive@0.4.1
	wyz@0.5.1
	xattr@1.3.1
	xdg-home@1.3.0
	zbus@5.1.1
	zbus_macros@5.1.1
	zbus_names@4.1.0
	zvariant@5.1.0
	zvariant_derive@5.1.0
	zvariant_utils@3.0.2
"

RUST_MIN_VER="1.74.1"

inherit llvm-r1 linux-info cargo rust-toolchain meson

DESCRIPTION="sched_ext schedulers and tools"
HOMEPAGE="https://github.com/sched-ext/scx"
SRC_URI="
	https://github.com/sched-ext/scx/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
	${CARGO_CRATE_URIS}
"

LICENSE="GPL-2"
# Dependent crate licenses
LICENSE+=" Apache-2.0 BSD-2 BSD ISC MIT MPL-2.0 Unicode-DFS-2016 ZLIB"
SLOT="0"
KEYWORDS="amd64"
IUSE="openrc systemd"

DEPEND="
	virtual/libelf:=
	sys-libs/zlib:=
	>=dev-libs/libbpf-1.5:=
	openrc? ( || (
		sys-apps/openrc
		sys-apps/openrc-navi
	) )
"
RDEPEND="
	${DEPEND}
"
BDEPEND="
	app-misc/jq
	>=dev-util/bpftool-7.5.0
	$(llvm_gen_dep '
		llvm-core/clang:${LLVM_SLOT}=[llvm_targets_BPF(-)]
	')
"

CONFIG_CHECK="
	~BPF
	~BPF_EVENTS
	~BPF_JIT
	~BPF_SYSCALL
	~DEBUG_INFO_BTF
	~FTRACE
	~SCHED_CLASS_EXT
"

QA_PREBUILT="/usr/bin/scx_loader"

pkg_setup() {
	linux-info_pkg_setup
	llvm-r1_pkg_setup
	rust_pkg_setup
}

src_prepare() {
	default

	# Inject the rust_abi value into install_rust_user_scheds
	sed -i "s;\${MESON_BUILD_ROOT};\${MESON_BUILD_ROOT}/$(rust_abi);" \
		meson-scripts/install_rust_user_scheds || die

	# bug #944832
	sed -i 's;^#!/usr/bin/;#!/sbin/;' \
		services/openrc/scx.initrd || die
}

src_configure() {
	BUILD_DIR="${BUILD_DIR:-${WORKDIR}/${P}-build}"

	local emesonargs=(
		-Dbpf_clang="$(get_llvm_prefix)/bin/clang"
		-Dbpftool=disabled
		-Dlibbpf_a=disabled
		-Dcargo="${EPREFIX}/usr/bin/cargo"
		-Dcargo_home="${ECARGO_HOME}"
		-Doffline=true
		-Denable_rust=true
		-Dlibalpm=disabled
		$(meson_feature openrc)
		$(meson_feature systemd)
	)

	cargo_env meson_src_configure
}

src_compile() {
	cargo_env meson_src_compile
}

src_test() {
	cargo_env meson_src_test
}

src_install() {
	cargo_env meson_src_install

	dodoc README.md

	local readme readme_name
	for readme in scheds/{rust,c}/*/README.md ./rust/*/README.md; do
		[[ -e ${readme} ]] || continue
		readme_name="${readme#*/rust/}"
		readme_name="${readme_name#*/c/}"
		readme_name="${readme_name%/README.md}"
		newdoc "${readme}" "${readme_name}.md"
	done
}
