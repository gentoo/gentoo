# Copyright 2020-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
	addr2line-0.19.0
	adler-1.0.2
	aho-corasick-0.7.18
	anyhow-1.0.57
	assert_cmd-2.0.4
	async-channel-1.6.1
	async-executor-1.4.1
	async-fs-1.5.0
	async-io-1.6.0
	async-lock-2.5.0
	async-net-1.6.1
	async-process-1.3.0
	async-task-4.2.0
	atomic-waker-1.0.0
	atty-0.2.14
	autocfg-1.1.0
	backtrace-0.3.67
	bitflags-1.3.2
	blocking-1.2.0
	bottom-0.8.0
	bstr-0.2.17
	byteorder-1.4.3
	cache-padded-1.2.0
	cargo-husky-1.5.0
	cassowary-0.3.0
	cc-1.0.73
	cfg-if-1.0.0
	clap-3.1.12
	clap_complete-3.1.2
	clap_lex-0.1.1
	clap_mangen-0.1.6
	concat-string-1.0.1
	concurrent-queue-1.2.2
	const_format-0.2.30
	const_format_proc_macros-0.2.29
	core-foundation-0.7.0
	core-foundation-0.9.3
	core-foundation-sys-0.7.0
	core-foundation-sys-0.8.3
	crossbeam-channel-0.5.4
	crossbeam-deque-0.8.1
	crossbeam-epoch-0.9.8
	crossbeam-utils-0.8.8
	crossterm-0.25.0
	crossterm_winapi-0.9.0
	ctrlc-3.2.4
	darling-0.10.2
	darling_core-0.10.2
	darling_macro-0.10.2
	difflib-0.4.0
	dirs-4.0.0
	dirs-sys-0.3.7
	doc-comment-0.3.3
	either-1.6.1
	errno-0.2.8
	errno-dragonfly-0.1.2
	event-listener-2.5.2
	fastrand-1.7.0
	fern-0.6.1
	filedescriptor-0.8.2
	float-cmp-0.9.0
	fnv-1.0.7
	futures-0.3.25
	futures-channel-0.3.25
	futures-core-0.3.25
	futures-executor-0.3.25
	futures-io-0.3.25
	futures-lite-1.12.0
	futures-macro-0.3.25
	futures-sink-0.3.25
	futures-task-0.3.25
	futures-timer-3.0.2
	futures-util-0.3.25
	fxhash-0.2.1
	getrandom-0.2.6
	gimli-0.27.0
	glob-0.3.0
	hashbrown-0.12.3
	heim-0.1.0-rc.1
	heim-common-0.1.0-rc.1
	heim-cpu-0.1.0-rc.1
	heim-disk-0.1.0-rc.1
	heim-memory-0.1.0-rc.1
	heim-net-0.1.0-rc.1
	heim-runtime-0.1.0-rc.1
	heim-sensors-0.1.0-rc.1
	hermit-abi-0.1.19
	hex-0.4.3
	humantime-2.1.0
	humantime-serde-1.1.1
	ident_case-1.0.1
	indexmap-1.9.2
	instant-0.1.12
	io-lifetimes-1.0.4
	itertools-0.10.5
	itoa-1.0.1
	kstring-2.0.0
	lazy_static-1.4.0
	lazycell-1.3.0
	libc-0.2.137
	libloading-0.7.3
	linux-raw-sys-0.1.4
	lock_api-0.4.7
	log-0.4.17
	macaddr-1.0.1
	mach-0.3.2
	mach2-0.4.1
	memchr-2.4.1
	memoffset-0.6.5
	miniz_oxide-0.6.2
	mio-0.8.5
	nix-0.19.1
	nix-0.23.1
	nix-0.26.1
	normalize-line-endings-0.3.0
	ntapi-0.3.7
	ntapi-0.4.0
	num-integer-0.1.44
	num-rational-0.3.2
	num-traits-0.2.14
	num_cpus-1.13.1
	num_threads-0.1.5
	nvml-wrapper-0.8.0
	nvml-wrapper-sys-0.6.0
	object-0.30.2
	once_cell-1.5.2
	os_str_bytes-6.0.0
	parking-2.0.0
	parking_lot-0.12.1
	parking_lot_core-0.9.4
	pin-project-lite-0.2.9
	pin-utils-0.1.0
	polling-2.2.0
	predicates-2.1.1
	predicates-core-1.0.3
	predicates-tree-1.0.5
	proc-macro2-1.0.49
	procfs-0.14.2
	quote-1.0.18
	rayon-1.5.2
	rayon-core-1.9.2
	redox_syscall-0.2.13
	redox_users-0.4.3
	regex-1.7.1
	regex-automata-0.1.10
	regex-syntax-0.6.28
	roff-0.2.1
	rustc-demangle-0.1.21
	rustix-0.36.6
	ryu-1.0.10
	same-file-1.0.6
	scopeguard-1.1.0
	serde-1.0.152
	serde_derive-1.0.152
	serde_json-1.0.82
	signal-hook-0.3.13
	signal-hook-mio-0.2.3
	signal-hook-registry-1.4.0
	slab-0.4.6
	smallvec-1.8.0
	smol-1.2.5
	socket2-0.4.4
	starship-battery-0.7.9
	static_assertions-1.1.0
	strsim-0.9.3
	strsim-0.10.0
	syn-1.0.107
	sysctl-0.5.2
	sysinfo-0.26.7
	termcolor-1.1.3
	terminal_size-0.1.17
	termtree-0.2.4
	textwrap-0.15.0
	thiserror-1.0.38
	thiserror-impl-1.0.38
	time-0.3.9
	time-macros-0.2.4
	toml-0.5.10
	tui-0.19.0
	typed-builder-0.10.0
	typenum-1.15.0
	unicode-ident-1.0.6
	unicode-segmentation-1.10.0
	unicode-width-0.1.10
	unicode-xid-0.2.2
	uom-0.30.0
	wait-timeout-0.2.0
	waker-fn-1.1.0
	walkdir-2.3.2
	wasi-0.10.2+wasi-snapshot-preview1
	wasi-0.11.0+wasi-snapshot-preview1
	wepoll-ffi-0.1.2
	widestring-0.4.3
	winapi-0.3.9
	winapi-i686-pc-windows-gnu-0.4.0
	winapi-util-0.1.5
	winapi-x86_64-pc-windows-gnu-0.4.0
	windows-0.44.0
	windows-sys-0.42.0
	windows-targets-0.42.1
	windows_aarch64_gnullvm-0.42.1
	windows_aarch64_msvc-0.42.1
	windows_i686_gnu-0.42.1
	windows_i686_msvc-0.42.1
	windows_x86_64_gnu-0.42.1
	windows_x86_64_gnullvm-0.42.1
	windows_x86_64_msvc-0.42.1
	wrapcenum-derive-0.4.0
"

inherit bash-completion-r1 cargo

DESCRIPTION="A graphical process/system monitor with a customizable interface"
HOMEPAGE="https://github.com/ClementTsang/bottom"
SRC_URI="$(cargo_crate_uris)"

LICENSE="0BSD Apache-2.0 Apache-2.0-with-LLVM-exceptions BSD BSD-2 Boost-1.0 ISC MIT Unicode-DFS-2016 Unlicense ZLIB"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ppc64"
IUSE="+battery"

# Rust packages ignore CFLAGS and LDFLAGS so let's silence the QA warnings
QA_FLAGS_IGNORED="usr/bin/btm"

src_prepare() {
	# Stripping symbols should be the choice of the user.
	sed -i '/strip = "symbols"/d' Cargo.toml || die "Unable to patch out symbol stripping"

	eapply_user
}

src_configure() {
	myfeatures=(
		$(usev battery)
	)

	# This will turn on generation of shell completion scripts
	export BTM_GENERATE=true

	# https://github.com/ClementTsang/bottom/blob/bacaca5548c2b23d261ef961ee6584b609529567/Cargo.toml#L63
	# fern and log features are for debugging only, so disable default features
	cargo_src_configure $(usev !debug --no-default-features)
}

src_install() {
	cargo_src_install

	# Find generated shell completion files. btm.bash can be present in multiple dirs if we build
	# additional features, so grab the first match only.
	local BUILD_DIR="$(dirname $(find target -name btm.bash -print -quit || die) || die)"

	newbashcomp "${BUILD_DIR}"/btm.bash btm

	insinto /usr/share/fish/vendor_completions.d
	doins "${BUILD_DIR}"/btm.fish

	insinto /usr/share/zsh/site-functions
	doins "${BUILD_DIR}"/_btm

	local DOCS=( README.md )
	einstalldocs
}
