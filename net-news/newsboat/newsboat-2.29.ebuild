# Copyright 2017-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
	addr2line-0.17.0
	adler-1.0.2
	aho-corasick-0.7.18
	android_system_properties-0.1.5
	autocfg-1.1.0
	backtrace-0.3.65
	bit-set-0.5.2
	bit-vec-0.6.3
	bitflags-1.3.2
	block-0.1.6
	bumpalo-3.10.0
	byteorder-1.4.3
	cc-1.0.73
	cfg-if-1.0.0
	chrono-0.4.22
	codespan-reporting-0.11.1
	core-foundation-sys-0.8.3
	curl-sys-0.4.57+curl-7.85.0
	cxx-1.0.76
	cxx-build-1.0.76
	cxxbridge-flags-1.0.76
	cxxbridge-macro-1.0.76
	dirs-4.0.0
	dirs-sys-0.3.7
	fastrand-1.8.0
	fnv-1.0.7
	form_urlencoded-1.1.0
	getrandom-0.2.7
	gettext-rs-0.7.0
	gettext-sys-0.21.3
	gimli-0.26.1
	iana-time-zone-0.1.47
	idna-0.3.0
	instant-0.1.12
	js-sys-0.3.59
	lazy_static-1.4.0
	lexopt-0.2.1
	libc-0.2.133
	libz-sys-1.1.8
	link-cplusplus-1.0.6
	locale_config-0.3.0
	log-0.4.17
	malloc_buf-0.0.6
	md5-0.7.0
	memchr-2.5.0
	minimal-lexical-0.2.1
	miniz_oxide-0.5.3
	natord-1.0.9
	nom-7.1.1
	num-integer-0.1.45
	num-traits-0.2.15
	objc-0.2.7
	objc-foundation-0.1.1
	objc_id-0.1.1
	object-0.28.4
	once_cell-1.15.0
	percent-encoding-2.2.0
	pkg-config-0.3.25
	ppv-lite86-0.2.16
	proc-macro2-1.0.40
	proptest-1.0.0
	quick-error-1.2.3
	quick-error-2.0.1
	quote-1.0.20
	rand-0.8.5
	rand_chacha-0.3.1
	rand_core-0.6.3
	rand_xorshift-0.3.0
	redox_syscall-0.2.13
	redox_users-0.4.3
	regex-1.5.6
	regex-syntax-0.6.26
	remove_dir_all-0.5.3
	rustc-demangle-0.1.21
	rusty-fork-0.3.0
	scratch-1.0.1
	section_testing-0.0.5
	syn-1.0.98
	temp-dir-0.1.11
	tempfile-3.3.0
	termcolor-1.1.3
	thiserror-1.0.31
	thiserror-impl-1.0.31
	time-0.1.44
	tinyvec-1.6.0
	tinyvec_macros-0.1.0
	unicode-bidi-0.3.8
	unicode-ident-1.0.1
	unicode-normalization-0.1.20
	unicode-width-0.1.10
	url-2.3.1
	vcpkg-0.2.15
	wait-timeout-0.2.0
	wasi-0.10.0+wasi-snapshot-preview1
	wasi-0.11.0+wasi-snapshot-preview1
	wasm-bindgen-0.2.82
	wasm-bindgen-backend-0.2.82
	wasm-bindgen-macro-0.2.82
	wasm-bindgen-macro-support-0.2.82
	wasm-bindgen-shared-0.2.82
	winapi-0.3.9
	winapi-i686-pc-windows-gnu-0.4.0
	winapi-util-0.1.5
	winapi-x86_64-pc-windows-gnu-0.4.0
	xdg-2.4.1
"

inherit flag-o-matic toolchain-funcs cargo

DESCRIPTION="An RSS/Atom feed reader for text terminals"
HOMEPAGE="https://newsboat.org/ https://github.com/newsboat/newsboat"
SRC_URI="
	https://newsboat.org/releases/${PV}/${P}.tar.xz
	$(cargo_crate_uris ${CRATES})
"

LICENSE="Apache-2.0 Apache-2.0-with-LLVM-exceptions Boost-1.0 BSD MIT Unlicense ZLIB"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~x86"

RDEPEND="
	>=dev-db/sqlite-3.5:3
	>=dev-libs/stfl-0.21
	>=net-misc/curl-7.21.6
	>=dev-libs/json-c-0.11:=
	dev-libs/libxml2
	sys-libs/ncurses:=[unicode(+)]
	sys-libs/zlib
	dev-libs/openssl
"
DEPEND="${RDEPEND}
	sys-devel/gettext
"
BDEPEND="
	>=dev-ruby/asciidoctor-1.5.3
	app-alternatives/awk
	virtual/pkgconfig
	>=virtual/rust-1.46.0
"

src_prepare() {
	default

	sed -i \
		-e "s/WARNFLAGS=-Werror -Wall/WARNFLAGS=-Wall/" \
		-e "s/BARE_CXXFLAGS=-std=c++11 -O2 -ggdb/BARE_CXXFLAGS=-std=c++11/" \
		Makefile || die
}

src_configure() {
	filter-lto  # bug #877657
	./config.sh || die
}

src_compile() {
	export CARGO_HOME="${ECARGO_HOME}"
	emake prefix="/usr" CC="$(tc-getCC)" CXX="$(tc-getCXX)" AR="$(tc-getAR)" RANLIB="$(tc-getRANLIB)"
}

src_test() {
	emake CC="${tc-getCC}" CXX="$(tc-getCXX)" AR="$(tc-getAR)" RANLIB="$(tc-getRANLIB)" check || die
}

src_install() {
	emake DESTDIR="${D}" prefix="/usr" docdir="/usr/share/doc/${PF}" install
	einstalldocs
}
