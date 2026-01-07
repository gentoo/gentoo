# Copyright 2023-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
	adler2@2.0.0
	aho-corasick@1.1.3
	ansi_colours@1.2.3
	anstream@0.6.18
	anstyle-parse@0.2.6
	anstyle-query@1.1.2
	anstyle-wincon@3.0.6
	anstyle@1.0.10
	anyhow@1.0.97
	assert_cmd@2.0.16
	autocfg@1.4.0
	base64@0.22.1
	bincode@1.3.3
	bit-set@0.8.0
	bit-vec@0.8.0
	bitflags@2.6.0
	bstr@1.11.3
	bugreport@0.5.1
	bytemuck@1.21.0
	bytesize@1.3.0
	cc@1.2.7
	cfg-if@1.0.0
	cfg_aliases@0.2.1
	clap@4.5.46
	clap_builder@4.5.46
	clap_lex@0.7.4
	clircle@0.6.1
	colorchoice@1.0.3
	console@0.16.0
	content_inspector@0.2.4
	core-foundation-sys@0.8.7
	crc32fast@1.4.2
	crossbeam-channel@0.5.15
	crossbeam-deque@0.8.6
	crossbeam-epoch@0.9.18
	crossbeam-utils@0.8.21
	crossterm@0.27.0
	crossterm_winapi@0.9.1
	darling@0.21.3
	darling_core@0.21.3
	darling_macro@0.21.3
	dashmap@5.5.3
	deranged@0.3.11
	difflib@0.4.0
	displaydoc@0.2.5
	dissimilar@1.0.9
	doc-comment@0.3.3
	either@1.13.0
	encode_unicode@1.0.0
	encoding_rs@0.8.35
	equivalent@1.0.1
	errno@0.3.10
	etcetera@0.11.0
	execute-command-macro-impl@0.1.10
	execute-command-macro@0.1.9
	execute-command-tokens@0.1.7
	execute@0.2.13
	expect-test@1.5.1
	fancy-regex@0.16.2
	fastrand@2.3.0
	flate2@1.1.2
	float-cmp@0.10.0
	fnv@1.0.7
	form_urlencoded@1.2.1
	generic-array@1.1.1
	getrandom@0.3.1
	git-version-macro@0.3.9
	git-version@0.3.9
	git2@0.20.2
	glob@0.3.2
	globset@0.4.16
	grep-cli@0.1.11
	hashbrown@0.14.5
	hashbrown@0.15.2
	icu_collections@1.5.0
	icu_locid@1.5.0
	icu_locid_transform@1.5.0
	icu_locid_transform_data@1.5.0
	icu_normalizer@1.5.0
	icu_normalizer_data@1.5.0
	icu_properties@1.5.1
	icu_properties_data@1.5.0
	icu_provider@1.5.0
	icu_provider_macros@1.5.0
	ident_case@1.0.1
	idna@1.0.3
	idna_adapter@1.2.0
	indexmap@2.8.0
	is_terminal_polyfill@1.70.1
	itertools@0.14.0
	itoa@1.0.14
	jobserver@0.1.32
	lazy_static@1.5.0
	libc@0.2.175
	libgit2-sys@0.18.2+1.9.1
	libz-sys@1.1.21
	linked-hash-map@0.5.6
	linux-raw-sys@0.4.15
	litemap@0.7.4
	lock_api@0.4.12
	log@0.4.22
	memchr@2.7.4
	miniz_oxide@0.8.9
	minus@5.6.1
	mio@0.8.11
	mio@1.1.0
	nix@0.30.1
	normalize-line-endings@0.3.0
	ntapi@0.4.1
	nu-ansi-term@0.50.1
	num-conv@0.1.0
	num-traits@0.2.19
	once_cell@1.20.2
	onig@6.5.1
	onig_sys@69.9.1
	parking_lot@0.12.3
	parking_lot_core@0.9.10
	path_abs@0.5.1
	percent-encoding@2.3.1
	pkg-config@0.3.31
	plist@1.7.0
	powerfmt@0.2.0
	predicates-core@1.0.9
	predicates-tree@1.0.12
	predicates@3.1.3
	prettyplease@0.2.37
	proc-macro2@1.0.95
	quick-xml@0.32.0
	quote@1.0.40
	rayon-core@1.12.1
	rayon@1.10.0
	redox_syscall@0.5.8
	regex-automata@0.4.13
	regex-syntax@0.8.5
	regex@1.12.2
	rgb@0.8.50
	rustix@0.38.43
	ryu@1.0.18
	same-file@1.0.6
	scopeguard@1.2.0
	semver@1.0.25
	serde@1.0.228
	serde_core@1.0.228
	serde_derive@1.0.228
	serde_json@1.0.135
	serde_spanned@1.0.0
	serde_with@3.15.1
	serde_with_macros@3.15.1
	serde_yaml@0.9.34+deprecated
	serial_test@2.0.0
	serial_test_derive@2.0.0
	shell-escape@0.1.5
	shell-words@1.1.0
	shlex@1.3.0
	signal-hook-mio@0.2.4
	signal-hook-registry@1.4.6
	signal-hook@0.3.18
	smallvec@1.13.2
	stable_deref_trait@1.2.0
	std_prelude@0.2.12
	strsim@0.11.1
	syn@2.0.108
	synstructure@0.13.1
	syntect@5.3.0
	sysinfo@0.33.1
	tempfile@3.16.0
	termcolor@1.4.1
	terminal-colorsaurus@1.0.1
	terminal-trx@0.2.5
	terminal_size@0.4.1
	termtree@0.5.1
	textwrap@0.16.2
	thiserror-impl@1.0.69
	thiserror-impl@2.0.16
	thiserror@1.0.69
	thiserror@2.0.16
	time-core@0.1.2
	time-macros@0.2.19
	time@0.3.37
	tinystr@0.7.6
	toml@0.9.1
	toml_datetime@0.7.0
	toml_parser@1.0.0
	toml_writer@1.0.0
	typenum@1.17.0
	unicode-ident@1.0.14
	unicode-segmentation@1.12.0
	unicode-width@0.2.1
	unsafe-libyaml@0.2.11
	url@2.5.4
	utf16_iter@1.0.5
	utf8_iter@1.0.4
	utf8parse@0.2.2
	vcpkg@0.2.15
	wait-timeout@0.2.1
	walkdir@2.5.0
	wasi@0.11.0+wasi-snapshot-preview1
	wasi@0.13.3+wasi-0.2.2
	wild@2.2.1
	winapi-i686-pc-windows-gnu@0.4.0
	winapi-util@0.1.9
	winapi-x86_64-pc-windows-gnu@0.4.0
	winapi@0.3.9
	windows-core@0.56.0
	windows-core@0.57.0
	windows-implement@0.56.0
	windows-implement@0.57.0
	windows-interface@0.56.0
	windows-interface@0.57.0
	windows-link@0.2.1
	windows-result@0.1.2
	windows-sys@0.48.0
	windows-sys@0.52.0
	windows-sys@0.59.0
	windows-sys@0.60.2
	windows-sys@0.61.2
	windows-targets@0.48.5
	windows-targets@0.52.6
	windows-targets@0.53.2
	windows@0.56.0
	windows@0.57.0
	windows_aarch64_gnullvm@0.48.5
	windows_aarch64_gnullvm@0.52.6
	windows_aarch64_gnullvm@0.53.0
	windows_aarch64_msvc@0.48.5
	windows_aarch64_msvc@0.52.6
	windows_aarch64_msvc@0.53.0
	windows_i686_gnu@0.48.5
	windows_i686_gnu@0.52.6
	windows_i686_gnu@0.53.0
	windows_i686_gnullvm@0.52.6
	windows_i686_gnullvm@0.53.0
	windows_i686_msvc@0.48.5
	windows_i686_msvc@0.52.6
	windows_i686_msvc@0.53.0
	windows_x86_64_gnu@0.48.5
	windows_x86_64_gnu@0.52.6
	windows_x86_64_gnu@0.53.0
	windows_x86_64_gnullvm@0.48.5
	windows_x86_64_gnullvm@0.52.6
	windows_x86_64_gnullvm@0.53.0
	windows_x86_64_msvc@0.48.5
	windows_x86_64_msvc@0.52.6
	windows_x86_64_msvc@0.53.0
	winnow@0.7.11
	wit-bindgen-rt@0.33.0
	write16@1.0.0
	writeable@0.5.5
	xterm-color@1.0.1
	yaml-rust@0.4.5
	yoke-derive@0.7.5
	yoke@0.7.5
	zerofrom-derive@0.1.5
	zerofrom@0.1.5
	zerovec-derive@0.10.3
	zerovec@0.10.4
"
RUST_MIN_VER="1.87.0"

inherit cargo shell-completion

DESCRIPTION="cat(1) clone with syntax highlighting and Git integration"
HOMEPAGE="https://github.com/sharkdp/bat"
SRC_URI="
	https://github.com/sharkdp/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
	${CARGO_CRATE_URIS}
"

LICENSE="|| ( MIT Apache-2.0 )"
# Dependent crate licenses
LICENSE+=" Apache-2.0 BSD-2 BSD LGPL-3+ MIT Unicode-3.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~loong ~mips ~ppc64 ~riscv ~x86"

BDEPEND="virtual/pkgconfig"
DEPEND="
	>=dev-libs/libgit2-1.9.1:=[threads]
	dev-libs/oniguruma:=
	virtual/zlib:=
"
# >app-backup/bacula-9.2[qt5] has file collisions, #686118
RDEPEND="${DEPEND}
	!>app-backup/bacula-9.2[qt5]
"

DOCS=( README.md CHANGELOG.md doc/alternatives.md )

QA_FLAGS_IGNORED="usr/bin/${PN}"

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
