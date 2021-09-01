# Copyright 2020-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
	addr2line-0.15.1
	adler-0.2.3
	aho-corasick-0.7.18
	ansi_term-0.11.0
	anyhow-1.0.40
	assert_cmd-1.0.3
	async-channel-1.5.1
	async-executor-1.4.0
	async-fs-1.5.0
	async-io-1.3.1
	async-lock-2.3.0
	async-net-1.5.0
	async-process-1.0.1
	async-task-4.0.3
	atomic-waker-1.0.0
	atty-0.2.14
	autocfg-1.0.1
	backtrace-0.3.59
	battery-0.7.8
	bitflags-1.2.1
	blocking-1.0.2
	bottom-0.6.3
	bstr-0.2.15
	byteorder-1.4.2
	cache-padded-1.1.1
	cargo-husky-1.5.0
	cassowary-0.3.0
	cc-1.0.67
	cfg-if-0.1.10
	cfg-if-1.0.0
	chrono-0.4.19
	clap-2.33.3
	concurrent-queue-1.2.2
	const_fn-0.4.4
	core-foundation-0.7.0
	core-foundation-0.9.1
	core-foundation-sys-0.7.0
	core-foundation-sys-0.8.2
	crc32fast-1.2.1
	crossbeam-channel-0.5.0
	crossbeam-deque-0.8.0
	crossbeam-epoch-0.9.1
	crossbeam-utils-0.8.1
	crossterm-0.18.2
	crossterm_winapi-0.6.2
	ctrlc-3.1.9
	difference-2.0.0
	dirs-3.0.2
	dirs-sys-0.3.6
	doc-comment-0.3.3
	either-1.6.1
	event-listener-2.5.1
	fastrand-1.4.0
	fern-0.6.0
	flate2-1.0.20
	float-cmp-0.8.0
	futures-0.3.14
	futures-channel-0.3.14
	futures-core-0.3.14
	futures-executor-0.3.14
	futures-io-0.3.14
	futures-lite-1.11.2
	futures-macro-0.3.14
	futures-sink-0.3.14
	futures-task-0.3.14
	futures-timer-3.0.2
	futures-util-0.3.14
	fxhash-0.2.1
	getrandom-0.2.3
	gimli-0.24.0
	glob-0.3.0
	hashbrown-0.9.1
	heim-0.1.0-rc.1
	heim-common-0.1.0-rc.1
	heim-cpu-0.1.0-rc.1
	heim-disk-0.1.0-rc.1
	heim-memory-0.1.0-rc.1
	heim-net-0.1.0-rc.1
	heim-runtime-0.1.0-rc.1
	heim-sensors-0.1.0-rc.1
	hermit-abi-0.1.17
	hex-0.4.3
	indexmap-1.6.2
	instant-0.1.9
	itertools-0.10.0
	lazy_static-1.4.0
	lazycell-1.3.0
	libc-0.2.94
	lock_api-0.4.2
	log-0.4.14
	macaddr-1.0.1
	mach-0.3.2
	memchr-2.4.0
	memoffset-0.6.1
	miniz_oxide-0.4.3
	mio-0.7.6
	miow-0.3.6
	nb-connect-1.0.2
	nix-0.19.1
	nix-0.20.0
	normalize-line-endings-0.3.0
	ntapi-0.3.6
	num-integer-0.1.44
	num-rational-0.3.2
	num-traits-0.2.14
	num_cpus-1.13.0
	object-0.24.0
	once_cell-1.5.2
	parking-2.0.0
	parking_lot-0.11.1
	parking_lot_core-0.8.1
	pin-project-lite-0.1.11
	pin-project-lite-0.2.4
	pin-utils-0.1.0
	polling-2.0.2
	predicates-1.0.8
	predicates-core-1.0.0
	predicates-tree-1.0.0
	proc-macro-hack-0.5.19
	proc-macro-nested-0.1.6
	proc-macro2-1.0.27
	procfs-0.9.1
	quote-1.0.7
	rayon-1.5.0
	rayon-core-1.9.0
	redox_syscall-0.1.57
	redox_syscall-0.2.8
	redox_users-0.4.0
	regex-1.5.4
	regex-automata-0.1.9
	regex-syntax-0.6.25
	rustc-demangle-0.1.18
	scopeguard-1.1.0
	serde-1.0.125
	serde_derive-1.0.125
	signal-hook-0.1.16
	signal-hook-registry-1.2.2
	slab-0.4.2
	smallvec-1.5.1
	smol-1.2.5
	socket2-0.3.17
	strsim-0.8.0
	syn-1.0.72
	sysinfo-0.18.2
	textwrap-0.11.0
	thiserror-1.0.24
	thiserror-impl-1.0.24
	time-0.1.44
	toml-0.5.8
	treeline-0.1.0
	tui-0.14.0
	typed-builder-0.9.0
	typenum-1.12.0
	unicode-segmentation-1.7.1
	unicode-width-0.1.8
	unicode-xid-0.2.1
	uom-0.30.0
	vec-arena-1.0.0
	vec_map-0.8.2
	wait-timeout-0.2.0
	waker-fn-1.1.0
	wasi-0.10.0+wasi-snapshot-preview1
	wepoll-sys-3.0.1
	widestring-0.4.3
	winapi-0.3.9
	winapi-i686-pc-windows-gnu-0.4.0
	winapi-x86_64-pc-windows-gnu-0.4.0
"

inherit bash-completion-r1 cargo

DESCRIPTION="A graphical process/system monitor with a customizable interface"
HOMEPAGE="https://github.com/ClementTsang/bottom"
SRC_URI="$(cargo_crate_uris)"

LICENSE="Apache-2.0 Apache-2.0-with-LLVM-exceptions BSD BSD-2 MIT MPL-2.0 Unlicense ZLIB"
SLOT="0"
KEYWORDS="amd64 ~arm64 ppc64"

# Rust packages ignore CFLAGS and LDFLAGS so let's silence the QA warnings
QA_FLAGS_IGNORED="usr/bin/btm"

src_configure() {
	# https://github.com/ClementTsang/bottom/blob/bacaca5548c2b23d261ef961ee6584b609529567/Cargo.toml#L63
	# fern and log features are for debugging only, so disable default features
	cargo_src_configure $(usev !debug --no-default-features)
}

src_install() {
	cargo_src_install

	# Find generated shell completion files. btm.bash can be present in multiple dirs if we build
	# additional features, so grab the first match only.
	local BUILD_DIR="$(dirname $(find target -name btm.bash -print -quit))"

	newbashcomp "${BUILD_DIR}"/btm.bash btm

	insinto /usr/share/fish/vendor_completions.d
	doins "${BUILD_DIR}"/btm.fish

	insinto /usr/share/zsh/site-functions
	doins "${BUILD_DIR}"/_btm

	local DOCS=( CHANGELOG.md README.md )
	einstalldocs
}
