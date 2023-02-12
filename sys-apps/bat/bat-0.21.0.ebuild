# Copyright 2017-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
	adler-1.0.2
	aho-corasick-0.7.18
	ansi_colours-1.1.1
	ansi_term-0.12.1
	assert_cmd-2.0.4
	atty-0.2.14
	autocfg-1.0.1
	base64-0.13.0
	bincode-1.3.3
	bit-set-0.5.2
	bit-vec-0.6.3
	bitflags-1.3.2
	bstr-0.2.17
	bugreport-0.5.0
	bytemuck-1.7.3
	bytesize-1.1.0
	cc-1.0.72
	cfg-if-1.0.0
	clap-2.34.0
	clircle-0.3.0
	console-0.15.0
	content_inspector-0.2.4
	crc32fast-1.3.0
	difflib-0.4.0
	dirs-next-2.0.0
	dirs-sys-next-0.1.2
	doc-comment-0.3.3
	either-1.6.1
	encode_unicode-0.3.6
	encoding-0.2.33
	encoding-index-japanese-1.20141219.5
	encoding-index-korean-1.20141219.5
	encoding-index-simpchinese-1.20141219.5
	encoding-index-singlebyte-1.20141219.5
	encoding-index-tradchinese-1.20141219.5
	encoding_index_tests-0.1.4
	fancy-regex-0.7.1
	fastrand-1.7.0
	flate2-1.0.23
	float-cmp-0.9.0
	fnv-1.0.7
	form_urlencoded-1.0.1
	getrandom-0.2.3
	git-version-0.3.5
	git-version-macro-0.3.5
	git2-0.14.2
	glob-0.3.0
	globset-0.4.8
	grep-cli-0.1.6
	hashbrown-0.11.2
	hermit-abi-0.1.19
	idna-0.2.3
	indexmap-1.7.0
	instant-0.1.12
	itertools-0.10.3
	itoa-0.4.8
	itoa-1.0.1
	jobserver-0.1.24
	lazy_static-1.4.0
	libc-0.2.125
	libgit2-sys-0.13.2+1.4.2
	libz-sys-1.1.3
	line-wrap-0.1.1
	linked-hash-map-0.5.4
	lock_api-0.4.5
	log-0.4.14
	matches-0.1.9
	memchr-2.4.1
	miniz_oxide-0.5.1
	nix-0.24.1
	normalize-line-endings-0.3.0
	num-traits-0.2.14
	once_cell-1.10.0
	onig-6.3.1
	onig_sys-69.7.1
	parking_lot-0.11.2
	parking_lot_core-0.8.5
	path_abs-0.5.1
	percent-encoding-2.1.0
	pkg-config-0.3.24
	plist-1.3.1
	predicates-2.1.1
	predicates-core-1.0.2
	predicates-tree-1.0.4
	proc-macro-error-1.0.4
	proc-macro-error-attr-1.0.4
	proc-macro-hack-0.5.19
	proc-macro2-1.0.36
	quote-1.0.14
	redox_syscall-0.2.10
	redox_users-0.4.0
	regex-1.5.5
	regex-automata-0.1.10
	regex-syntax-0.6.25
	remove_dir_all-0.5.3
	rgb-0.8.31
	rustversion-1.0.6
	ryu-1.0.9
	safemem-0.3.3
	same-file-1.0.6
	scopeguard-1.1.0
	semver-1.0.7
	serde-1.0.136
	serde_derive-1.0.136
	serde_json-1.0.74
	serde_yaml-0.8.23
	serial_test-0.6.0
	serial_test_derive-0.6.0
	shell-escape-0.1.5
	shell-words-1.1.0
	smallvec-1.7.0
	std_prelude-0.2.12
	strsim-0.8.0
	syn-1.0.85
	syntect-5.0.0
	sys-info-0.9.1
	tempfile-3.3.0
	term_size-0.3.2
	termcolor-1.1.2
	terminal_size-0.1.17
	termtree-0.2.3
	textwrap-0.11.0
	thiserror-1.0.31
	thiserror-impl-1.0.31
	time-0.3.5
	tinyvec-1.5.1
	tinyvec_macros-0.1.0
	unicode-bidi-0.3.7
	unicode-normalization-0.1.19
	unicode-width-0.1.9
	unicode-xid-0.2.2
	url-2.2.2
	vcpkg-0.2.15
	vec_map-0.8.2
	version_check-0.9.4
	wait-timeout-0.2.0
	walkdir-2.3.2
	wasi-0.10.2+wasi-snapshot-preview1
	wild-2.0.4
	winapi-0.3.9
	winapi-i686-pc-windows-gnu-0.4.0
	winapi-util-0.1.5
	winapi-x86_64-pc-windows-gnu-0.4.0
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

LICENSE="Apache-2.0 BSD BSD-2 CC0-1.0 LGPL-3+ MIT"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~ppc64 ~riscv ~x86"

BDEPEND="virtual/pkgconfig"
DEPEND="
	>=dev-libs/libgit2-1.1.0:=[threads]
	dev-libs/oniguruma:=
"
# >app-backup/bacula-9.2[qt5] has file collisions, #686118
RDEPEND="${DEPEND}
	!>app-backup/bacula-9.2[qt5]
"

DOCS=( README.md CHANGELOG.md doc/alternatives.md )

QA_FLAGS_IGNORED="usr/bin/${PN}"

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
