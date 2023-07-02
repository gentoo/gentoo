# Copyright 2020-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
	addr2line-0.19.0
	adler-1.0.2
	ahash-0.8.3
	aho-corasick-1.0.1
	anstream-0.3.2
	anstyle-1.0.0
	anstyle-parse-0.2.0
	anstyle-query-1.0.0
	anstyle-wincon-1.0.1
	anyhow-1.0.71
	assert_cmd-2.0.11
	autocfg-1.1.0
	backtrace-0.3.67
	bitflags-1.3.2
	bottom-0.9.1
	bstr-1.4.0
	byteorder-1.4.3
	cargo-husky-1.5.0
	cassowary-0.3.0
	cc-1.0.79
	cfg-if-1.0.0
	clap-4.2.7
	clap_builder-4.2.7
	clap_complete-4.2.3
	clap_lex-0.4.1
	clap_mangen-0.2.10
	colorchoice-1.0.0
	concat-string-1.0.1
	core-foundation-0.9.3
	core-foundation-sys-0.8.4
	crossbeam-channel-0.5.8
	crossbeam-deque-0.8.3
	crossbeam-epoch-0.9.14
	crossbeam-utils-0.8.15
	crossterm-0.26.1
	crossterm_winapi-0.9.0
	ctrlc-3.2.5
	darling-0.10.2
	darling_core-0.10.2
	darling_macro-0.10.2
	difflib-0.4.0
	dirs-5.0.1
	dirs-sys-0.4.1
	doc-comment-0.3.3
	either-1.8.1
	enum-as-inner-0.5.1
	errno-0.3.1
	errno-dragonfly-0.1.2
	fern-0.6.2
	filedescriptor-0.8.2
	float-cmp-0.9.0
	fnv-1.0.7
	getrandom-0.2.9
	gimli-0.27.2
	hashbrown-0.12.3
	hashbrown-0.13.2
	heck-0.4.1
	hermit-abi-0.2.6
	hermit-abi-0.3.1
	hex-0.4.3
	humantime-2.1.0
	humantime-serde-1.1.1
	ident_case-1.0.1
	indexmap-1.9.3
	io-lifetimes-1.0.10
	is-terminal-0.4.7
	itertools-0.10.5
	itoa-1.0.6
	kstring-2.0.0
	lazy_static-1.4.0
	lazycell-1.3.0
	libc-0.2.144
	libloading-0.7.4
	linux-raw-sys-0.1.4
	linux-raw-sys-0.3.7
	lock_api-0.4.9
	log-0.4.17
	mach2-0.4.1
	memchr-2.5.0
	memoffset-0.8.0
	miniz_oxide-0.6.2
	mio-0.8.6
	nix-0.26.2
	normalize-line-endings-0.3.0
	ntapi-0.4.1
	num-traits-0.2.15
	num_cpus-1.15.0
	nvml-wrapper-0.9.0
	nvml-wrapper-sys-0.7.0
	object-0.30.3
	once_cell-1.17.1
	option-ext-0.2.0
	parking_lot-0.12.1
	parking_lot_core-0.9.7
	predicates-3.0.3
	predicates-core-1.0.6
	predicates-tree-1.0.9
	proc-macro2-1.0.56
	procfs-0.15.1
	quote-1.0.27
	ratatui-0.20.1
	rayon-1.7.0
	rayon-core-1.11.0
	redox_syscall-0.2.16
	redox_users-0.4.3
	regex-1.8.1
	regex-automata-0.1.10
	regex-syntax-0.7.1
	roff-0.2.1
	rustc-demangle-0.1.23
	rustix-0.36.13
	rustix-0.37.19
	ryu-1.0.13
	same-file-1.0.6
	scopeguard-1.1.0
	serde-1.0.163
	serde_derive-1.0.163
	serde_json-1.0.96
	serde_spanned-0.6.1
	signal-hook-0.3.15
	signal-hook-mio-0.2.3
	signal-hook-registry-1.4.1
	smallvec-1.10.0
	starship-battery-0.8.0
	static_assertions-1.1.0
	strsim-0.9.3
	strsim-0.10.0
	syn-1.0.109
	syn-2.0.15
	sysctl-0.5.4
	sysinfo-0.29.0
	terminal_size-0.2.6
	termtree-0.4.1
	thiserror-1.0.40
	thiserror-impl-1.0.40
	time-0.3.21
	time-core-0.1.1
	time-macros-0.2.9
	toml_datetime-0.6.1
	toml_edit-0.19.8
	typed-builder-0.14.0
	typenum-1.16.0
	unicode-ident-1.0.8
	unicode-segmentation-1.10.1
	unicode-width-0.1.10
	uom-0.34.0
	utf8parse-0.2.1
	version_check-0.9.4
	wait-timeout-0.2.0
	walkdir-2.3.3
	wasi-0.11.0+wasi-snapshot-preview1
	winapi-0.3.9
	winapi-i686-pc-windows-gnu-0.4.0
	winapi-util-0.1.5
	winapi-x86_64-pc-windows-gnu-0.4.0
	windows-0.48.0
	windows-sys-0.45.0
	windows-sys-0.48.0
	windows-targets-0.42.2
	windows-targets-0.48.0
	windows_aarch64_gnullvm-0.42.2
	windows_aarch64_gnullvm-0.48.0
	windows_aarch64_msvc-0.42.2
	windows_aarch64_msvc-0.48.0
	windows_i686_gnu-0.42.2
	windows_i686_gnu-0.48.0
	windows_i686_msvc-0.42.2
	windows_i686_msvc-0.48.0
	windows_x86_64_gnu-0.42.2
	windows_x86_64_gnu-0.48.0
	windows_x86_64_gnullvm-0.42.2
	windows_x86_64_gnullvm-0.48.0
	windows_x86_64_msvc-0.42.2
	windows_x86_64_msvc-0.48.0
	winnow-0.4.6
	wrapcenum-derive-0.4.0
"

inherit bash-completion-r1 cargo

DESCRIPTION="A graphical process/system monitor with a customizable interface"
HOMEPAGE="https://github.com/ClementTsang/bottom"
SRC_URI="$(cargo_crate_uris)"

LICENSE="0BSD Apache-2.0 Apache-2.0-with-LLVM-exceptions BSD-2 Boost-1.0 ISC MIT MPL-2.0 Unicode-DFS-2016 Unlicense ZLIB"
SLOT="0"
KEYWORDS="amd64 arm64 ppc64"
IUSE="+battery +gpu +zfs"

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
		$(usev gpu)
		$(usev zfs)
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
