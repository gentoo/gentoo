# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
	adler-1.0.2
	aho-corasick-0.7.19
	ansi_colours-1.2.1
	assert_cmd-2.0.8
	atty-0.2.14
	autocfg-1.1.0
	base64-0.13.0
	bincode-1.3.3
	bit-set-0.5.3
	bit-vec-0.6.3
	bitflags-1.3.2
	bstr-1.1.0
	bugreport-0.5.0
	bytemuck-1.12.1
	bytesize-1.1.0
	cc-1.0.73
	cfg-if-1.0.0
	clap-4.1.8
	clap_lex-0.3.2
	clircle-0.3.0
	console-0.15.5
	content_inspector-0.2.4
	crc32fast-1.3.2
	difflib-0.4.0
	dirs-5.0.0
	dirs-sys-0.4.0
	dissimilar-1.0.5
	doc-comment-0.3.3
	either-1.8.0
	encode_unicode-0.3.6
	encoding-0.2.33
	encoding-index-japanese-1.20141219.5
	encoding-index-korean-1.20141219.5
	encoding-index-simpchinese-1.20141219.5
	encoding-index-singlebyte-1.20141219.5
	encoding-index-tradchinese-1.20141219.5
	encoding_index_tests-0.1.4
	errno-0.2.8
	errno-dragonfly-0.1.2
	expect-test-1.4.0
	fancy-regex-0.7.1
	fastrand-1.8.0
	flate2-1.0.25
	float-cmp-0.9.0
	fnv-1.0.7
	form_urlencoded-1.1.0
	getrandom-0.2.7
	git-version-0.3.5
	git-version-macro-0.3.5
	git2-0.16.1
	glob-0.3.0
	globset-0.4.10
	grep-cli-0.1.7
	hashbrown-0.12.3
	hermit-abi-0.1.19
	hermit-abi-0.3.1
	idna-0.3.0
	indexmap-1.9.1
	instant-0.1.12
	io-lifetimes-1.0.5
	is-terminal-0.4.4
	itertools-0.10.5
	itoa-1.0.3
	jobserver-0.1.25
	lazy_static-1.4.0
	libc-0.2.137
	libgit2-sys-0.14.2+1.5.1
	libz-sys-1.1.8
	line-wrap-0.1.1
	linked-hash-map-0.5.6
	linux-raw-sys-0.1.4
	lock_api-0.4.9
	log-0.4.17
	memchr-2.5.0
	miniz_oxide-0.6.2
	nix-0.26.2
	normalize-line-endings-0.3.0
	nu-ansi-term-0.47.0
	num-traits-0.2.15
	num_threads-0.1.6
	once_cell-1.17.0
	onig-6.4.0
	onig_sys-69.8.1
	os_str_bytes-6.3.0
	parking_lot-0.11.2
	parking_lot_core-0.8.5
	path_abs-0.5.1
	percent-encoding-2.2.0
	pkg-config-0.3.25
	plist-1.3.1
	predicates-2.1.5
	predicates-core-1.0.3
	predicates-tree-1.0.5
	proc-macro-error-1.0.4
	proc-macro-error-attr-1.0.4
	proc-macro-hack-0.5.19
	proc-macro2-1.0.46
	quote-1.0.21
	redox_syscall-0.2.16
	redox_users-0.4.3
	regex-1.7.0
	regex-automata-0.1.10
	regex-syntax-0.6.27
	remove_dir_all-0.5.3
	rgb-0.8.34
	rustix-0.36.8
	rustversion-1.0.9
	ryu-1.0.11
	safemem-0.3.3
	same-file-1.0.6
	scopeguard-1.1.0
	semver-1.0.16
	serde-1.0.152
	serde_derive-1.0.152
	serde_json-1.0.85
	serde_yaml-0.8.26
	serial_test-0.6.0
	serial_test_derive-0.6.0
	shell-escape-0.1.5
	shell-words-1.1.0
	smallvec-1.10.0
	static_assertions-1.1.0
	std_prelude-0.2.12
	strsim-0.10.0
	syn-1.0.104
	syntect-5.0.0
	sys-info-0.9.1
	tempfile-3.3.0
	termcolor-1.1.3
	terminal_size-0.2.5
	termtree-0.2.4
	thiserror-1.0.38
	thiserror-impl-1.0.38
	time-0.3.14
	tinyvec-1.6.0
	tinyvec_macros-0.1.0
	unicode-bidi-0.3.8
	unicode-ident-1.0.4
	unicode-normalization-0.1.22
	unicode-width-0.1.10
	url-2.3.1
	vcpkg-0.2.15
	version_check-0.9.4
	wait-timeout-0.2.0
	walkdir-2.3.2
	wasi-0.11.0+wasi-snapshot-preview1
	wild-2.1.0
	winapi-0.3.9
	winapi-i686-pc-windows-gnu-0.4.0
	winapi-util-0.1.5
	winapi-x86_64-pc-windows-gnu-0.4.0
	windows-sys-0.42.0
	windows-sys-0.45.0
	windows-targets-0.42.1
	windows_aarch64_gnullvm-0.42.1
	windows_aarch64_msvc-0.42.1
	windows_i686_gnu-0.42.1
	windows_i686_msvc-0.42.1
	windows_x86_64_gnu-0.42.1
	windows_x86_64_gnullvm-0.42.1
	windows_x86_64_msvc-0.42.1
	xml-rs-0.8.4
	yaml-rust-0.4.5
"

inherit bash-completion-r1 cargo

DESCRIPTION="cat(1) clone with syntax highlighting and Git integration"
HOMEPAGE="https://github.com/sharkdp/bat"
SRC_URI="
	https://github.com/sharkdp/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
	$(cargo_crate_uris)
"

LICENSE="|| ( MIT Apache-2.0 )"
# Dependent crate licenses
LICENSE+=" Apache-2.0 BSD-2 BSD CC0-1.0 LGPL-3+ MIT Unicode-DFS-2016"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~riscv ~x86"

BDEPEND="virtual/pkgconfig"
DEPEND="
	>=dev-libs/libgit2-1.1.0:=[threads]
	dev-libs/oniguruma:=
	sys-libs/zlib
"
# >app-backup/bacula-9.2[qt5] has file collisions, #686118
RDEPEND="${DEPEND}
	!>app-backup/bacula-9.2[qt5]
"

DOCS=( README.md CHANGELOG.md doc/alternatives.md )

QA_FLAGS_IGNORED="usr/bin/${PN}"
QA_PRESTRIPPED="${QA_FLAGS_IGNORED}"

src_configure() {
	export RUSTONIG_SYSTEM_LIBONIG=1
	export LIBGIT2_SYS_USE_PKG_CONFIG=1
	export PKG_CONFIG_ALLOW_CROSS=1
}

src_install() {
	cargo_src_install

	einstalldocs

	local build_dir=( target/$(usex debug{,} release)/build/${PN}-*/out )
	cd ${build_dir[0]} || die "Cannot change directory to ${PN} build"

	doman assets/manual/bat.1

	newbashcomp assets/completions/${PN}.bash ${PN}

	insinto /usr/share/zsh/site-functions
	newins assets/completions/${PN}.zsh _${PN}

	insinto /usr/share/fish/vendor_completions.d
	doins assets/completions/${PN}.fish
}
