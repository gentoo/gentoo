# Copyright 2023-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
	adler2@2.0.0
	aho-corasick@1.1.2
	ansi_colours@1.2.3
	anstream@0.6.18
	anstyle-parse@0.2.0
	anstyle-query@1.0.0
	anstyle-wincon@3.0.6
	anstyle@1.0.0
	anyhow@1.0.86
	assert_cmd@2.0.12
	autocfg@1.1.0
	base64@0.22.1
	bincode@1.3.3
	bit-set@0.5.3
	bit-vec@0.6.3
	bitflags@1.3.2
	bitflags@2.4.0
	bstr@1.8.0
	bugreport@0.5.0
	bytemuck@1.12.1
	bytesize@1.3.0
	cc@1.0.83
	cfg-if@1.0.0
	cfg_aliases@0.2.1
	clap@4.5.13
	clap_builder@4.5.13
	clap_lex@0.7.4
	clircle@0.6.1
	colorchoice@1.0.0
	console@0.15.10
	content_inspector@0.2.4
	crc32fast@1.3.2
	darling@0.20.3
	darling_core@0.20.3
	darling_macro@0.20.3
	dashmap@5.4.0
	deranged@0.3.11
	difflib@0.4.0
	dissimilar@1.0.5
	doc-comment@0.3.3
	either@1.8.0
	encode_unicode@1.0.0
	encoding_rs@0.8.35
	equivalent@1.0.1
	errno-dragonfly@0.1.2
	errno@0.3.3
	etcetera@0.8.0
	execute-command-macro-impl@0.1.10
	execute-command-macro@0.1.9
	execute-command-tokens@0.1.7
	execute@0.2.13
	expect-test@1.5.0
	fancy-regex@0.11.0
	fastrand@2.0.0
	flate2@1.0.35
	float-cmp@0.10.0
	fnv@1.0.7
	form_urlencoded@1.2.1
	generic-array@1.1.1
	git-version-macro@0.3.9
	git-version@0.3.9
	git2@0.19.0
	glob@0.3.1
	globset@0.4.15
	grep-cli@0.1.11
	hashbrown@0.12.3
	hashbrown@0.14.1
	hermit-abi@0.3.9
	home@0.5.9
	ident_case@1.0.1
	idna@0.5.0
	indexmap@2.3.0
	is_terminal_polyfill@1.70.1
	itertools@0.13.0
	itoa@1.0.3
	jobserver@0.1.25
	lazy_static@1.4.0
	libc@0.2.161
	libgit2-sys@0.17.0+1.8.1
	libz-sys@1.1.8
	linked-hash-map@0.5.6
	linux-raw-sys@0.4.10
	lock_api@0.4.9
	log@0.4.20
	memchr@2.7.4
	miniz_oxide@0.8.0
	mio@1.0.0
	nix@0.29.0
	normalize-line-endings@0.3.0
	nu-ansi-term@0.50.0
	num-conv@0.1.0
	num-traits@0.2.15
	once_cell@1.20.2
	onig@6.4.0
	onig_sys@69.8.1
	parking_lot@0.12.1
	parking_lot_core@0.9.7
	path_abs@0.5.1
	percent-encoding@2.3.1
	pkg-config@0.3.25
	plist@1.7.0
	powerfmt@0.2.0
	predicates-core@1.0.6
	predicates-tree@1.0.5
	predicates@3.1.3
	proc-macro2@1.0.92
	quick-xml@0.32.0
	quote@1.0.35
	redox_syscall@0.2.16
	redox_syscall@0.4.1
	regex-automata@0.4.7
	regex-syntax@0.8.2
	regex@1.10.6
	rgb@0.8.34
	rustix@0.38.21
	ryu@1.0.11
	same-file@1.0.6
	scopeguard@1.1.0
	semver@1.0.23
	serde@1.0.217
	serde_derive@1.0.217
	serde_json@1.0.85
	serde_spanned@0.6.8
	serde_with@3.12.0
	serde_with_macros@3.12.0
	serde_yaml@0.9.29
	serial_test@2.0.0
	serial_test_derive@2.0.0
	shell-escape@0.1.5
	shell-words@1.1.0
	smallvec@1.10.0
	std_prelude@0.2.12
	strsim@0.10.0
	strsim@0.11.1
	syn@2.0.93
	syntect@5.2.0
	sys-info@0.9.1
	tempfile@3.8.1
	termcolor@1.4.0
	terminal-colorsaurus@0.4.7
	terminal-trx@0.2.3
	terminal_size@0.3.0
	termtree@0.2.4
	thiserror-impl@1.0.61
	thiserror@1.0.61
	time-core@0.1.2
	time-macros@0.2.18
	time@0.3.36
	tinyvec@1.6.0
	tinyvec_macros@0.1.0
	toml@0.8.19
	toml_datetime@0.6.8
	toml_edit@0.22.22
	typenum@1.17.0
	unicode-bidi@0.3.18
	unicode-ident@1.0.4
	unicode-normalization@0.1.22
	unicode-width@0.1.13
	unicode-width@0.2.0
	unsafe-libyaml@0.2.10
	url@2.5.2
	utf8parse@0.2.1
	vcpkg@0.2.15
	wait-timeout@0.2.0
	walkdir@2.5.0
	wasi@0.11.0+wasi-snapshot-preview1
	wild@2.2.1
	winapi-i686-pc-windows-gnu@0.4.0
	winapi-util@0.1.6
	winapi-x86_64-pc-windows-gnu@0.4.0
	winapi@0.3.9
	windows-core@0.56.0
	windows-implement@0.56.0
	windows-interface@0.56.0
	windows-result@0.1.2
	windows-sys@0.45.0
	windows-sys@0.48.0
	windows-sys@0.52.0
	windows-sys@0.59.0
	windows-targets@0.42.1
	windows-targets@0.48.0
	windows-targets@0.52.6
	windows@0.56.0
	windows_aarch64_gnullvm@0.42.1
	windows_aarch64_gnullvm@0.48.0
	windows_aarch64_gnullvm@0.52.6
	windows_aarch64_msvc@0.42.1
	windows_aarch64_msvc@0.48.0
	windows_aarch64_msvc@0.52.6
	windows_i686_gnu@0.42.1
	windows_i686_gnu@0.48.0
	windows_i686_gnu@0.52.6
	windows_i686_gnullvm@0.52.6
	windows_i686_msvc@0.42.1
	windows_i686_msvc@0.48.0
	windows_i686_msvc@0.52.6
	windows_x86_64_gnu@0.42.1
	windows_x86_64_gnu@0.48.0
	windows_x86_64_gnu@0.52.6
	windows_x86_64_gnullvm@0.42.1
	windows_x86_64_gnullvm@0.48.0
	windows_x86_64_gnullvm@0.52.6
	windows_x86_64_msvc@0.42.1
	windows_x86_64_msvc@0.48.0
	windows_x86_64_msvc@0.52.6
	winnow@0.6.20
	yaml-rust@0.4.5
"

inherit cargo shell-completion

DESCRIPTION="cat(1) clone with syntax highlighting and Git integration"
HOMEPAGE="https://github.com/sharkdp/bat"
SRC_URI="
	https://github.com/sharkdp/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
	${CARGO_CRATE_URIS}
"

LICENSE="|| ( MIT Apache-2.0 )"
# Dependent crate licenses
LICENSE+=" Apache-2.0 BSD-2 BSD LGPL-3+ MIT Unicode-DFS-2016"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~loong ~mips ~ppc64 ~riscv ~x86"

BDEPEND="virtual/pkgconfig"
DEPEND="
	>=dev-libs/libgit2-1.7.0:=[threads]
	dev-libs/oniguruma:=
	sys-libs/zlib
"
# >app-backup/bacula-9.2[qt5] has file collisions, #686118
RDEPEND="${DEPEND}
	!>app-backup/bacula-9.2[qt5]
"

DOCS=( README.md CHANGELOG.md doc/alternatives.md )

QA_FLAGS_IGNORED="usr/bin/${PN}"

src_prepare() {
	default

	# libgit2-sys unnecessarily(?) requests <libgit2-1.9.0, bump to 2 for now
	sed -e '/range_version/s/1\.9\.0/2/' \
		-i "${ECARGO_VENDOR}"/libgit2-sys-0.17.0+1.8.1/build.rs || die
}

src_configure() {
	export RUSTONIG_SYSTEM_LIBONIG=1
	export LIBGIT2_NO_VENDOR=1
	export PKG_CONFIG_ALLOW_CROSS=1
	sed -i -e 's/strip = true/strip = false/g' Cargo.toml || die
	cargo_src_configure
}

src_test() {
	# Set COLUMNS for deterministic help output, #913364
	local -x COLUMNS=100

	cargo_src_test
}

src_install() {
	cargo_src_install

	einstalldocs

	local build_dir=( "$(cargo_target_dir)"/build/${PN}-*/out )
	cd "${build_dir[0]}" || die "Cannot change directory to ${PN} build"

	doman assets/manual/bat.1

	newbashcomp assets/completions/${PN}.bash ${PN}
	newzshcomp assets/completions/${PN}.zsh _${PN}
	dofishcomp assets/completions/${PN}.fish
}
