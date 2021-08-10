# Copyright 2017-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CRATES="
	adler-1.0.2
	aho-corasick-0.7.18
	ansi_colours-1.0.2
	ansi_term-0.11.0
	ansi_term-0.12.1
	assert_cmd-1.0.3
	atty-0.2.14
	autocfg-1.0.1
	base64-0.13.0
	bincode-1.3.3
	bit-set-0.5.2
	bit-vec-0.6.3
	bitflags-1.2.1
	bstr-0.2.16
	bugreport-0.4.0
	byteorder-1.4.3
	cc-1.0.67
	cfg-if-1.0.0
	chrono-0.4.19
	clap-2.33.3
	clircle-0.3.0
	console-0.14.1
	content_inspector-0.2.4
	crc32fast-1.2.1
	difference-2.0.0
	dirs-next-2.0.0
	dirs-sys-next-0.1.2
	doc-comment-0.3.3
	dtoa-0.4.8
	encode_unicode-0.3.6
	encoding-0.2.33
	encoding-index-japanese-1.20141219.5
	encoding-index-korean-1.20141219.5
	encoding-index-simpchinese-1.20141219.5
	encoding-index-singlebyte-1.20141219.5
	encoding-index-tradchinese-1.20141219.5
	encoding_index_tests-0.1.4
	error-chain-0.12.4
	fancy-regex-0.3.5
	flate2-1.0.20
	float-cmp-0.8.0
	fnv-1.0.7
	form_urlencoded-1.0.1
	getrandom-0.2.2
	git-version-0.3.4
	git-version-macro-0.3.4
	git2-0.13.19
	glob-0.3.0
	globset-0.4.6
	hashbrown-0.9.1
	hermit-abi-0.1.18
	idna-0.2.3
	indexmap-1.6.2
	instant-0.1.9
	itoa-0.4.7
	jobserver-0.1.22
	lazy_static-1.4.0
	lazycell-1.3.0
	libc-0.2.94
	libgit2-sys-0.12.20+1.1.0
	libz-sys-1.1.3
	line-wrap-0.1.1
	linked-hash-map-0.5.4
	lock_api-0.4.4
	log-0.4.14
	matches-0.1.8
	memchr-2.4.0
	miniz_oxide-0.4.4
	nix-0.20.0
	normalize-line-endings-0.3.0
	num-integer-0.1.44
	num-traits-0.2.14
	onig-6.1.1
	onig_sys-69.6.0
	parking_lot-0.11.1
	parking_lot_core-0.8.3
	path_abs-0.5.1
	percent-encoding-2.1.0
	pest-2.1.3
	pkg-config-0.3.19
	plist-1.1.0
	ppv-lite86-0.2.10
	predicates-1.0.8
	predicates-core-1.0.2
	predicates-tree-1.0.2
	proc-macro-hack-0.5.19
	proc-macro2-1.0.26
	quote-1.0.9
	rand-0.8.3
	rand_chacha-0.3.0
	rand_core-0.6.2
	rand_hc-0.3.0
	redox_syscall-0.2.8
	redox_users-0.4.0
	regex-1.5.4
	regex-automata-0.1.9
	regex-syntax-0.6.25
	remove_dir_all-0.5.3
	ryu-1.0.5
	safemem-0.3.3
	same-file-1.0.6
	scopeguard-1.1.0
	semver-0.11.0
	semver-parser-0.10.2
	serde-1.0.126
	serde_derive-1.0.126
	serde_json-1.0.64
	serde_yaml-0.8.17
	serial_test-0.5.1
	serial_test_derive-0.5.1
	shell-escape-0.1.5
	shell-words-1.0.0
	smallvec-1.6.1
	std_prelude-0.2.12
	strsim-0.8.0
	syn-1.0.72
	syntect-4.5.0
	sys-info-0.9.0
	tempfile-3.2.0
	term_size-0.3.2
	terminal_size-0.1.16
	textwrap-0.11.0
	tinyvec-1.2.0
	tinyvec_macros-0.1.0
	treeline-0.1.0
	ucd-trie-0.1.3
	unicode-bidi-0.3.5
	unicode-normalization-0.1.17
	unicode-width-0.1.8
	unicode-xid-0.2.2
	url-2.2.2
	vcpkg-0.2.12
	vec_map-0.8.2
	version_check-0.9.3
	wait-timeout-0.2.0
	walkdir-2.3.2
	wasi-0.10.2+wasi-snapshot-preview1
	wild-2.0.4
	winapi-0.3.9
	winapi-i686-pc-windows-gnu-0.4.0
	winapi-util-0.1.5
	winapi-x86_64-pc-windows-gnu-0.4.0
	xml-rs-0.8.3
	yaml-rust-0.4.5
"

inherit cargo

DESCRIPTION="cat(1) clone with syntax highlighting and Git integration"
# Double check the homepage as the cargo_metadata crate
# does not provide this value so instead repository is used
HOMEPAGE="https://github.com/sharkdp/bat"
SRC_URI="https://github.com/sharkdp/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
SRC_URI+=" $(cargo_crate_uris ${CRATES})"

LICENSE="Apache-2.0 Boost-1.0 BSD BSD-2 CC0-1.0 ISC LGPL-3+ MIT Apache-2.0 Unlicense ZLIB"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~x86"

BDEPEND="virtual/pkgconfig"
DEPEND="
	>=dev-libs/libgit2-1.1.0:=[threads]
	dev-libs/oniguruma:=
"
# >app-backup/bacula-9.2[qt5] has file collisions, #686118
RDEPEND="${DEPEND}
	!>app-backup/bacula-9.2[qt5]
"

DOCS=( README.md doc/alternatives.md )

QA_FLAGS_IGNORED="/usr/bin/bat"

src_configure() {
	export RUSTONIG_SYSTEM_LIBONIG=1
	export LIBGIT2_SYS_USE_PKG_CONFIG=1
	export PKG_CONFIG_ALLOW_CROSS=1
}

src_install() {
	cargo_src_install

	einstalldocs

	doman target/release/build/bat-*/out/assets/manual/bat.1

	insinto /usr/share/fish/vendor_completions.d/
	doins target/release/build/bat-*/out/assets/completions/bat.fish

	# Hack to find/install generated zsh completions files as it can be present in
	# multiple directories
	local BUILD_DIR="$(dirname $(find target/release -name bat.zsh -print -quit || die) || die)"
	insinto /usr/share/zsh/site-functions/
	newins "${BUILD_DIR}"/bat.zsh _${PN}
}
