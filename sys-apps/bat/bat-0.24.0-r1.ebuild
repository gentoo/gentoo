# Copyright 2023-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
	adler@1.0.2
	aho-corasick@0.7.19
	aho-corasick@1.0.1
	ansi_colours@1.2.1
	anstream@0.6.4
	anstyle-parse@0.2.0
	anstyle-query@1.0.0
	anstyle-wincon@3.0.1
	anstyle@0.3.5
	anstyle@1.0.0
	assert_cmd@2.0.10
	autocfg@1.1.0
	base64@0.21.0
	bincode@1.3.3
	bit-set@0.5.3
	bit-vec@0.6.3
	bitflags@1.3.2
	bitflags@2.4.0
	bstr@1.6.0
	bugreport@0.5.0
	bytemuck@1.12.1
	bytesize@1.3.0
	cc@1.0.73
	cfg-if@1.0.0
	clap@4.4.6
	clap_builder@4.4.6
	clap_lex@0.5.0
	clircle@0.4.0
	colorchoice@1.0.0
	console@0.15.5
	content_inspector@0.2.4
	crc32fast@1.3.2
	dashmap@5.4.0
	difflib@0.4.0
	dissimilar@1.0.5
	doc-comment@0.3.3
	dunce@1.0.3
	either@1.8.0
	encode_unicode@0.3.6
	encoding_rs@0.8.33
	equivalent@1.0.1
	errno-dragonfly@0.1.2
	errno@0.3.3
	etcetera@0.8.0
	expect-test@1.4.1
	fancy-regex@0.7.1
	fastrand@2.0.0
	flate2@1.0.27
	float-cmp@0.9.0
	fnv@1.0.7
	form_urlencoded@1.1.0
	fsio@0.4.0
	getrandom@0.2.7
	git-version-macro@0.3.5
	git-version@0.3.5
	git2@0.18.0
	glob@0.3.0
	globset@0.4.10
	grep-cli@0.1.9
	hashbrown@0.12.3
	hashbrown@0.14.1
	home@0.5.5
	idna@0.3.0
	indexmap@1.9.1
	indexmap@2.0.2
	itertools@0.10.5
	itoa@1.0.3
	jobserver@0.1.25
	lazy_static@1.4.0
	libc@0.2.147
	libgit2-sys@0.16.1+1.7.1
	libz-sys@1.1.8
	line-wrap@0.1.1
	linked-hash-map@0.5.6
	linux-raw-sys@0.4.5
	lock_api@0.4.9
	log@0.4.17
	memchr@2.5.0
	miniz_oxide@0.7.1
	nix@0.26.2
	normalize-line-endings@0.3.0
	nu-ansi-term@0.49.0
	num-traits@0.2.15
	num_threads@0.1.6
	once_cell@1.18.0
	onig@6.4.0
	onig_sys@69.8.1
	os_str_bytes@6.4.1
	parking_lot@0.12.1
	parking_lot_core@0.9.7
	path_abs@0.5.1
	percent-encoding@2.2.0
	pkg-config@0.3.25
	plist@1.4.3
	ppv-lite86@0.2.17
	predicates-core@1.0.6
	predicates-tree@1.0.5
	predicates@3.0.3
	proc-macro-hack@0.5.19
	proc-macro2@1.0.66
	quick-xml@0.28.1
	quote@1.0.26
	rand@0.8.5
	rand_chacha@0.3.1
	rand_core@0.6.4
	redox_syscall@0.2.16
	redox_syscall@0.3.5
	regex-automata@0.3.7
	regex-syntax@0.6.27
	regex-syntax@0.7.2
	regex@1.8.3
	rgb@0.8.34
	run_script@0.10.0
	rustix@0.38.11
	ryu@1.0.11
	safemem@0.3.3
	same-file@1.0.6
	scopeguard@1.1.0
	semver@1.0.17
	serde@1.0.163
	serde_derive@1.0.163
	serde_json@1.0.85
	serde_yaml@0.9.25
	serial_test@2.0.0
	serial_test_derive@2.0.0
	shell-escape@0.1.5
	shell-words@1.1.0
	smallvec@1.10.0
	static_assertions@1.1.0
	std_prelude@0.2.12
	strsim@0.10.0
	syn@1.0.104
	syn@2.0.12
	syntect@5.0.0
	sys-info@0.9.1
	tempfile@3.8.0
	termcolor@1.1.3
	terminal_size@0.3.0
	termtree@0.2.4
	thiserror-impl@1.0.40
	thiserror@1.0.40
	time@0.3.14
	tinyvec@1.6.0
	tinyvec_macros@0.1.0
	unicode-bidi@0.3.8
	unicode-ident@1.0.4
	unicode-normalization@0.1.22
	unicode-width@0.1.10
	unsafe-libyaml@0.2.9
	url@2.3.1
	utf8parse@0.2.1
	vcpkg@0.2.15
	wait-timeout@0.2.0
	walkdir@2.3.3
	wasi@0.11.0+wasi-snapshot-preview1
	wild@2.1.0
	winapi-i686-pc-windows-gnu@0.4.0
	winapi-util@0.1.5
	winapi-x86_64-pc-windows-gnu@0.4.0
	winapi@0.3.9
	windows-sys@0.42.0
	windows-sys@0.45.0
	windows-sys@0.48.0
	windows-targets@0.42.1
	windows-targets@0.48.0
	windows_aarch64_gnullvm@0.42.1
	windows_aarch64_gnullvm@0.48.0
	windows_aarch64_msvc@0.42.1
	windows_aarch64_msvc@0.48.0
	windows_i686_gnu@0.42.1
	windows_i686_gnu@0.48.0
	windows_i686_msvc@0.42.1
	windows_i686_msvc@0.48.0
	windows_x86_64_gnu@0.42.1
	windows_x86_64_gnu@0.48.0
	windows_x86_64_gnullvm@0.42.1
	windows_x86_64_gnullvm@0.48.0
	windows_x86_64_msvc@0.42.1
	windows_x86_64_msvc@0.48.0
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
LICENSE+="
	Apache-2.0 BSD-2 BSD LGPL-3+ MIT Unicode-DFS-2016
	|| ( CC0-1.0 MIT-0 )
"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~riscv ~x86"

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

	# libgit2-sys unnecessarily(?) requests <libgit2-1.8.0, bump to 2 for now
	sed -e '/range_version/s/1\.8\.0/2/' \
		-i "${ECARGO_VENDOR}"/libgit2-sys-0.16.1+1.7.1/build.rs || die
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
