# Copyright 2017-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
	aho-corasick-0.7.18
	ansi_term-0.11.0
	anyhow-1.0.44
	atty-0.2.14
	autocfg-1.0.1
	bitflags-1.3.2
	block-buffer-0.7.3
	block-padding-0.1.5
	bstr-0.2.17
	byte-tools-0.3.1
	byteorder-1.4.3
	camino-1.0.5
	cargo-lock-7.0.1
	cargo-platform-0.1.2
	cargo_metadata-0.14.0
	cc-1.0.71
	cfg-if-1.0.0
	clap-2.33.3
	crates-index-0.17.0
	crossbeam-utils-0.8.5
	cvss-1.0.2
	digest-0.8.1
	either-1.6.1
	fake-simd-0.1.2
	fnv-1.0.7
	form_urlencoded-1.0.1
	fs-err-2.6.0
	generic-array-0.12.4
	getrandom-0.2.3
	git2-0.13.23
	glob-0.3.0
	globset-0.4.8
	globwalk-0.8.1
	heck-0.3.3
	hermit-abi-0.1.19
	hex-0.4.3
	home-0.5.3
	humantime-2.1.0
	humantime-serde-1.0.1
	idna-0.2.3
	ignore-0.4.18
	itertools-0.10.1
	itoa-0.4.8
	jobserver-0.1.24
	lazy_static-1.4.0
	libc-0.2.103
	libgit2-sys-0.12.24+1.3.0
	libssh2-sys-0.2.21
	libz-sys-1.1.3
	log-0.4.14
	maplit-1.0.2
	matches-0.1.9
	memchr-2.4.1
	once_cell-1.8.0
	opaque-debug-0.2.3
	openssl-probe-0.1.4
	openssl-sys-0.9.67
	percent-encoding-2.1.0
	pest-2.1.3
	pest_derive-2.1.0
	pest_generator-2.1.3
	pest_meta-2.1.3
	phf-0.10.0
	phf_generator-0.10.0
	phf_macros-0.10.0
	phf_shared-0.10.0
	pkg-config-0.3.20
	platforms-1.1.0
	ppv-lite86-0.2.10
	proc-macro-error-1.0.4
	proc-macro-error-attr-1.0.4
	proc-macro-hack-0.5.19
	proc-macro2-1.0.29
	quote-1.0.10
	rand-0.8.4
	rand_chacha-0.3.1
	rand_core-0.6.3
	rand_hc-0.3.1
	regex-1.5.4
	regex-syntax-0.6.25
	rustsec-0.24.3
	ryu-1.0.5
	same-file-1.0.6
	semver-1.0.4
	serde-1.0.130
	serde_derive-1.0.130
	serde_json-1.0.68
	sha-1-0.8.2
	siphasher-0.3.7
	smartstring-0.2.9
	smol_str-0.1.17
	static_assertions-1.1.0
	strsim-0.8.0
	structopt-0.3.23
	structopt-derive-0.4.16
	syn-1.0.80
	tera-1.12.1
	textwrap-0.11.0
	thiserror-1.0.25
	thiserror-impl-1.0.25
	thread_local-1.1.3
	time-0.3.3
	tinyvec-1.5.0
	tinyvec_macros-0.1.0
	toml-0.5.8
	typenum-1.14.0
	ucd-trie-0.1.3
	unic-char-property-0.9.0
	unic-char-range-0.9.0
	unic-common-0.9.0
	unic-segment-0.9.0
	unic-ucd-segment-0.9.0
	unic-ucd-version-0.9.0
	unicode-bidi-0.3.6
	unicode-normalization-0.1.19
	unicode-segmentation-1.8.0
	unicode-width-0.1.9
	unicode-xid-0.2.2
	url-2.2.2
	vcpkg-0.2.15
	vec_map-0.8.2
	version_check-0.9.3
	walkdir-2.3.2
	wasi-0.10.2+wasi-snapshot-preview1
	winapi-0.3.9
	winapi-i686-pc-windows-gnu-0.4.0
	winapi-util-0.1.5
	winapi-x86_64-pc-windows-gnu-0.4.0
"

inherit cargo

DESCRIPTION="Generates an ebuild for a package using the in-tree eclasses."
HOMEPAGE="https://gitweb.gentoo.org/proj/cargo-ebuild.git"
SRC_URI="https://gitweb.gentoo.org/proj/${PN}.git/snapshot/${P}.tar.bz2
	$(cargo_crate_uris)"

LICENSE="Apache-2.0 Apache-2.0-with-LLVM-exceptions BSD Boost-1.0 MIT MPL-2.0 Unlicense ZLIB"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ppc64"

DEPEND="
	dev-libs/libgit2:=
	dev-libs/openssl:0=
	net-libs/libssh2:=
"

RDEPEND="${DEPEND}"

QA_FLAGS_IGNORED="usr/bin/cargo-ebuild"

src_configure() {
	export LIBGIT2_SYS_USE_PKG_CONFIG=1 LIBSSH2_SYS_USE_PKG_CONFIG=1 PKG_CONFIG_ALLOW_CROSS=1
	cargo_src_configure
}

src_install() {
	cargo_src_install
	einstalldocs
}
