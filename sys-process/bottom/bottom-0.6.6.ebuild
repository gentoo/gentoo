# Copyright 2020-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
	addr2line-0.16.0
	adler-1.0.2
	aho-corasick-0.7.18
	ansi_term-0.11.0
	anyhow-1.0.44
	assert_cmd-1.0.8
	async-channel-1.6.1
	async-executor-1.4.1
	async-fs-1.5.0
	async-io-1.6.0
	async-lock-2.4.0
	async-net-1.6.1
	async-process-1.2.0
	async-task-4.0.3
	atomic-waker-1.0.0
	atty-0.2.14
	autocfg-1.0.1
	backtrace-0.3.61
	battery-0.7.8
	bitflags-1.3.2
	blocking-1.0.2
	bottom-0.6.6
	bstr-0.2.17
	byteorder-1.4.3
	cache-padded-1.1.1
	cargo-husky-1.5.0
	cassowary-0.3.0
	cc-1.0.71
	cfg-if-1.0.0
	clap-2.33.3
	concurrent-queue-1.2.2
	core-foundation-0.7.0
	core-foundation-0.9.2
	core-foundation-sys-0.7.0
	core-foundation-sys-0.8.3
	crc32fast-1.2.1
	crossbeam-channel-0.5.1
	crossbeam-deque-0.8.1
	crossbeam-epoch-0.9.5
	crossbeam-utils-0.8.5
	crossterm-0.18.2
	crossterm_winapi-0.6.2
	ctrlc-3.2.1
	difference-2.0.0
	difflib-0.4.0
	dirs-3.0.2
	dirs-sys-0.3.6
	doc-comment-0.3.3
	either-1.6.1
	event-listener-2.5.1
	fastrand-1.5.0
	fern-0.6.0
	flate2-1.0.22
	float-cmp-0.8.0
	futures-0.3.17
	futures-channel-0.3.17
	futures-core-0.3.17
	futures-executor-0.3.17
	futures-io-0.3.17
	futures-lite-1.12.0
	futures-macro-0.3.17
	futures-sink-0.3.17
	futures-task-0.3.17
	futures-timer-3.0.2
	futures-util-0.3.17
	fxhash-0.2.1
	getrandom-0.2.3
	gimli-0.25.0
	glob-0.3.0
	hashbrown-0.11.2
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
	indexmap-1.7.0
	instant-0.1.11
	itertools-0.10.1
	itoa-0.4.8
	lazy_static-1.4.0
	lazycell-1.3.0
	libc-0.2.104
	lock_api-0.4.5
	log-0.4.14
	macaddr-1.0.1
	mach-0.3.2
	memchr-2.4.1
	memoffset-0.6.4
	miniz_oxide-0.4.4
	mio-0.7.14
	miow-0.3.7
	nix-0.19.1
	nix-0.23.0
	normalize-line-endings-0.3.0
	ntapi-0.3.6
	num-integer-0.1.44
	num-rational-0.3.2
	num-traits-0.2.14
	num_cpus-1.13.0
	object-0.26.2
	once_cell-1.5.2
	parking-2.0.0
	parking_lot-0.11.2
	parking_lot_core-0.8.5
	pin-project-lite-0.2.7
	pin-utils-0.1.0
	polling-2.1.0
	predicates-1.0.8
	predicates-2.0.3
	predicates-core-1.0.2
	predicates-tree-1.0.4
	proc-macro-hack-0.5.19
	proc-macro-nested-0.1.7
	proc-macro2-1.0.30
	procfs-0.11.0
	quote-1.0.10
	rayon-1.5.1
	rayon-core-1.9.1
	redox_syscall-0.2.10
	redox_users-0.4.0
	regex-1.5.4
	regex-automata-0.1.10
	regex-syntax-0.6.25
	rustc-demangle-0.1.21
	scopeguard-1.1.0
	serde-1.0.130
	serde_derive-1.0.130
	signal-hook-0.1.17
	signal-hook-0.3.10
	signal-hook-registry-1.4.0
	slab-0.4.5
	smallvec-1.7.0
	smol-1.2.5
	socket2-0.4.2
	strsim-0.8.0
	syn-1.0.80
	sysinfo-0.18.2
	termtree-0.2.1
	textwrap-0.11.0
	thiserror-1.0.30
	thiserror-impl-1.0.30
	time-0.3.3
	time-macros-0.2.3
	toml-0.5.8
	tui-0.14.0
	typed-builder-0.9.1
	typenum-1.14.0
	unicode-segmentation-1.8.0
	unicode-width-0.1.9
	unicode-xid-0.2.2
	uom-0.30.0
	vec_map-0.8.2
	wait-timeout-0.2.0
	waker-fn-1.1.0
	wasi-0.10.2+wasi-snapshot-preview1
	wepoll-ffi-0.1.2
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
KEYWORDS="~amd64 ~arm64 ~ppc64"
IUSE="+battery"

# Rust packages ignore CFLAGS and LDFLAGS so let's silence the QA warnings
QA_FLAGS_IGNORED="usr/bin/btm"

src_configure() {
	myfeatures=(
		$(usev battery)
	)

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
