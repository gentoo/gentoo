# Copyright 2020-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
	addr2line-0.21.0
	adler-1.0.2
	ahash-0.8.3
	aho-corasick-1.0.4
	allocator-api2-0.2.16
	anstream-0.3.2
	anstyle-1.0.1
	anstyle-parse-0.2.1
	anstyle-query-1.0.0
	anstyle-wincon-1.0.2
	anyhow-1.0.75
	assert_cmd-2.0.12
	autocfg-1.1.0
	backtrace-0.3.69
	bitflags-1.3.2
	bitflags-2.4.0
	bottom-0.9.6
	bstr-1.6.0
	byteorder-1.4.3
	cargo-husky-1.5.0
	cassowary-0.3.0
	cc-1.0.82
	cfg-if-1.0.0
	clap-4.3.23
	clap_builder-4.3.23
	clap_complete-4.3.2
	clap_lex-0.5.0
	clap_mangen-0.2.12
	colorchoice-1.0.0
	concat-string-1.0.1
	core-foundation-0.9.3
	core-foundation-sys-0.8.4
	crossbeam-channel-0.5.8
	crossbeam-deque-0.8.3
	crossbeam-epoch-0.9.15
	crossbeam-utils-0.8.16
	crossterm-0.26.1
	crossterm-0.27.0
	crossterm_winapi-0.9.1
	ctrlc-3.4.0
	darling-0.10.2
	darling_core-0.10.2
	darling_macro-0.10.2
	deranged-0.3.7
	difflib-0.4.0
	dirs-5.0.1
	dirs-sys-0.4.1
	doc-comment-0.3.3
	either-1.9.0
	enum-as-inner-0.5.1
	equivalent-1.0.1
	errno-0.3.2
	errno-dragonfly-0.1.2
	fern-0.6.2
	filedescriptor-0.8.2
	float-cmp-0.9.0
	fnv-1.0.7
	getrandom-0.2.10
	gimli-0.28.0
	hashbrown-0.14.0
	heck-0.4.1
	hermit-abi-0.3.2
	humantime-2.1.0
	ident_case-1.0.1
	indexmap-2.0.0
	indoc-2.0.3
	io-lifetimes-1.0.11
	is-terminal-0.4.9
	itertools-0.10.5
	itertools-0.11.0
	itoa-1.0.9
	kstring-2.0.0
	lazycell-1.3.0
	libc-0.2.147
	libloading-0.7.4
	linux-raw-sys-0.3.8
	linux-raw-sys-0.4.5
	lock_api-0.4.10
	log-0.4.20
	mach2-0.4.1
	memchr-2.5.0
	memoffset-0.9.0
	miniz_oxide-0.7.1
	mio-0.8.8
	nix-0.26.2
	normalize-line-endings-0.3.0
	ntapi-0.4.1
	num-traits-0.2.16
	num_cpus-1.16.0
	nvml-wrapper-0.9.0
	nvml-wrapper-sys-0.7.0
	object-0.32.0
	once_cell-1.18.0
	option-ext-0.2.0
	parking_lot-0.12.1
	parking_lot_core-0.9.8
	paste-1.0.14
	predicates-3.0.3
	predicates-core-1.0.6
	predicates-tree-1.0.9
	proc-macro2-1.0.66
	quote-1.0.33
	ratatui-0.22.0
	rayon-1.7.0
	rayon-core-1.11.0
	redox_syscall-0.2.16
	redox_syscall-0.3.5
	redox_users-0.4.3
	regex-1.9.4
	regex-automata-0.3.7
	regex-syntax-0.7.5
	roff-0.2.1
	rustc-demangle-0.1.23
	rustix-0.37.23
	rustix-0.38.9
	ryu-1.0.15
	same-file-1.0.6
	scopeguard-1.2.0
	serde-1.0.188
	serde_derive-1.0.188
	serde_json-1.0.105
	serde_spanned-0.6.3
	signal-hook-0.3.17
	signal-hook-mio-0.2.3
	signal-hook-registry-1.4.1
	smallvec-1.11.0
	starship-battery-0.8.2
	static_assertions-1.1.0
	strsim-0.9.3
	strsim-0.10.0
	syn-1.0.109
	syn-2.0.29
	sysctl-0.5.4
	sysinfo-0.29.8
	terminal_size-0.2.6
	termtree-0.4.1
	thiserror-1.0.47
	thiserror-impl-1.0.47
	time-0.3.27
	time-core-0.1.1
	time-macros-0.2.13
	toml_datetime-0.6.3
	toml_edit-0.19.14
	typenum-1.16.0
	unicode-ident-1.0.11
	unicode-segmentation-1.10.1
	unicode-width-0.1.10
	uom-0.35.0
	utf8parse-0.2.1
	version_check-0.9.4
	wait-timeout-0.2.0
	walkdir-2.3.3
	wasi-0.11.0+wasi-snapshot-preview1
	winapi-0.3.9
	winapi-i686-pc-windows-gnu-0.4.0
	winapi-util-0.1.5
	winapi-x86_64-pc-windows-gnu-0.4.0
	windows-0.51.1
	windows-core-0.51.1
	windows-sys-0.48.0
	windows-targets-0.48.5
	windows_aarch64_gnullvm-0.48.5
	windows_aarch64_msvc-0.48.5
	windows_i686_gnu-0.48.5
	windows_i686_msvc-0.48.5
	windows_x86_64_gnu-0.48.5
	windows_x86_64_gnullvm-0.48.5
	windows_x86_64_msvc-0.48.5
	winnow-0.5.14
	wrapcenum-derive-0.4.0
"

inherit bash-completion-r1 cargo

DESCRIPTION="A graphical process/system monitor with a customizable interface"
HOMEPAGE="https://github.com/ClementTsang/bottom"
SRC_URI="$(cargo_crate_uris)"

LICENSE="0BSD Apache-2.0 Apache-2.0-with-LLVM-exceptions BSD-2 Boost-1.0 ISC MIT MPL-2.0 Unicode-DFS-2016 Unlicense ZLIB"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ppc64"
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
