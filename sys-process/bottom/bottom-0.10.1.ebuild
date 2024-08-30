# Copyright 2020-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
	addr2line@0.22.0
	adler@1.0.2
	ahash@0.8.11
	aho-corasick@1.1.3
	allocator-api2@0.2.18
	anstream@0.6.15
	anstyle-parse@0.2.5
	anstyle-query@1.1.1
	anstyle-wincon@3.0.4
	anstyle@1.0.8
	anyhow@1.0.86
	assert_cmd@2.0.15
	autocfg@1.3.0
	backtrace@0.3.73
	base64@0.22.1
	bitflags@1.3.2
	bitflags@2.6.0
	bottom@0.10.1
	bstr@1.10.0
	byteorder@1.5.0
	cargo-husky@1.5.0
	cassowary@0.3.0
	castaway@0.2.3
	cc@1.1.7
	cfg-if@1.0.0
	cfg_aliases@0.1.1
	cfg_aliases@0.2.1
	clap@4.5.13
	clap_builder@4.5.13
	clap_complete@4.5.12
	clap_complete_fig@4.5.2
	clap_complete_nushell@4.5.3
	clap_derive@4.5.13
	clap_lex@0.7.2
	clap_mangen@0.2.23
	colorchoice@1.0.2
	compact_str@0.7.1
	concat-string@1.0.1
	core-foundation-sys@0.8.6
	core-foundation@0.9.4
	crossbeam-deque@0.8.5
	crossbeam-epoch@0.9.18
	crossbeam-utils@0.8.20
	crossterm@0.27.0
	crossterm_winapi@0.9.1
	ctrlc@3.4.4
	darling@0.20.10
	darling_core@0.20.10
	darling_macro@0.20.10
	deranged@0.3.11
	difflib@0.4.0
	dirs-sys@0.4.1
	dirs@5.0.1
	doc-comment@0.3.3
	downcast-rs@1.2.1
	dyn-clone@1.0.17
	either@1.13.0
	enum-as-inner@0.6.0
	equivalent@1.0.1
	errno@0.3.9
	fern@0.6.2
	filedescriptor@0.8.2
	float-cmp@0.9.0
	fnv@1.0.7
	getrandom@0.2.15
	gimli@0.29.0
	hashbrown@0.14.5
	heck@0.4.1
	heck@0.5.0
	humantime@2.1.0
	ident_case@1.0.1
	indexmap@2.3.0
	indoc@2.0.5
	ioctl-rs@0.1.6
	is_terminal_polyfill@1.70.1
	itertools@0.13.0
	itoa@1.0.11
	lazy_static@1.5.0
	lazycell@1.3.0
	libc@0.2.155
	libloading@0.8.5
	libredox@0.1.3
	linux-raw-sys@0.4.14
	lock_api@0.4.12
	log@0.4.22
	lru@0.12.4
	mach2@0.4.2
	memchr@2.7.4
	memoffset@0.6.5
	miniz_oxide@0.7.4
	mio@0.8.11
	nix@0.25.1
	nix@0.28.0
	nix@0.29.0
	normalize-line-endings@0.3.0
	ntapi@0.4.1
	num-conv@0.1.0
	num-traits@0.2.19
	num_threads@0.1.7
	nvml-wrapper-sys@0.8.0
	nvml-wrapper@0.10.0
	object@0.36.2
	once_cell@1.19.0
	option-ext@0.2.0
	parking_lot@0.12.3
	parking_lot_core@0.9.10
	paste@1.0.15
	pin-utils@0.1.0
	plist@1.7.0
	portable-pty@0.8.1
	powerfmt@0.2.0
	predicates-core@1.0.8
	predicates-tree@1.0.11
	predicates@3.1.2
	proc-macro2@1.0.86
	quick-xml@0.32.0
	quote@1.0.36
	ratatui@0.27.0
	rayon-core@1.12.1
	rayon@1.10.0
	redox_syscall@0.5.3
	redox_users@0.4.5
	regex-automata@0.4.7
	regex-syntax@0.8.4
	regex@1.10.5
	roff@0.2.2
	rustc-demangle@0.1.24
	rustix@0.38.34
	rustversion@1.0.17
	ryu@1.0.18
	same-file@1.0.6
	schemars@0.8.21
	schemars_derive@0.8.21
	scopeguard@1.2.0
	serde@1.0.204
	serde_derive@1.0.204
	serde_derive_internals@0.29.1
	serde_json@1.0.121
	serde_spanned@0.6.7
	serial-core@0.4.0
	serial-unix@0.4.0
	serial-windows@0.4.0
	serial@0.4.0
	shared_library@0.1.9
	shell-words@1.1.0
	signal-hook-mio@0.2.4
	signal-hook-registry@1.4.2
	signal-hook@0.3.17
	smallvec@1.13.2
	stability@0.2.1
	starship-battery@0.9.1
	static_assertions@1.1.0
	strsim@0.11.1
	strum@0.26.3
	strum_macros@0.26.4
	syn@2.0.72
	sysctl@0.5.5
	sysinfo@0.30.13
	terminal_size@0.3.0
	termios@0.2.2
	termtree@0.4.1
	thiserror-impl@1.0.63
	thiserror@1.0.63
	time-core@0.1.2
	time-macros@0.2.18
	time@0.3.36
	toml_datetime@0.6.8
	toml_edit@0.22.20
	typenum@1.17.0
	unicode-ellipsis@0.2.0
	unicode-ident@1.0.12
	unicode-segmentation@1.11.0
	unicode-truncate@1.1.0
	unicode-width@0.1.13
	uom@0.36.0
	utf8parse@0.2.2
	version_check@0.9.5
	wait-timeout@0.2.0
	walkdir@2.5.0
	wasi@0.11.0+wasi-snapshot-preview1
	winapi-i686-pc-windows-gnu@0.4.0
	winapi-util@0.1.8
	winapi-x86_64-pc-windows-gnu@0.4.0
	winapi@0.3.9
	windows-core@0.52.0
	windows-core@0.58.0
	windows-implement@0.58.0
	windows-interface@0.58.0
	windows-result@0.2.0
	windows-strings@0.1.0
	windows-sys@0.48.0
	windows-sys@0.52.0
	windows-targets@0.48.5
	windows-targets@0.52.6
	windows@0.52.0
	windows@0.58.0
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
	winreg@0.10.1
	wrapcenum-derive@0.4.1
	zerocopy-derive@0.7.35
	zerocopy@0.7.35
"

inherit bash-completion-r1 cargo

DESCRIPTION="A graphical process/system monitor with a customizable interface"
HOMEPAGE="https://github.com/ClementTsang/bottom"
SRC_URI="${CARGO_CRATE_URIS}"

LICENSE="MIT"
# Dependent crate licenses
LICENSE+=" Apache-2.0 ISC MIT MPL-2.0 Unicode-DFS-2016"
# cargo-husky-1.5.0
LICENSE+=" MIT "
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ppc64"
IUSE="+battery +gpu +zfs"

# Rust packages ignore CFLAGS and LDFLAGS so let's silence the QA warnings
QA_FLAGS_IGNORED="usr/bin/btm"

src_prepare() {
	# Stripping symbols should be the choice of the user.
	sed -i '/strip = "symbols"/d' Cargo.toml || die "Unable to patch out symbol stripping"

	default
}

src_configure() {
	local myfeatures=(
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
	local build_dir="$(dirname $(find target -name btm.bash -print -quit || die) || die)"

	newbashcomp "${build_dir}"/btm.bash btm

	insinto /usr/share/fish/vendor_completions.d
	doins "${build_dir}"/btm.fish

	insinto /usr/share/zsh/site-functions
	doins "${build_dir}"/_btm

	local DOCS=( README.md )
	einstalldocs
}
