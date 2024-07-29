# Copyright 2017-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
	addr2line@0.21.0
	adler@1.0.2
	aho-corasick@1.1.1
	android-tzdata@0.1.1
	android_system_properties@0.1.5
	autocfg@1.1.0
	backtrace@0.3.69
	bit-set@0.5.3
	bit-vec@0.6.3
	bitflags@1.3.2
	bitflags@2.4.1
	block@0.1.6
	bumpalo@3.14.0
	byteorder@1.4.3
	cc@1.0.83
	cfg-if@1.0.0
	chrono@0.4.31
	codespan-reporting@0.11.1
	core-foundation-sys@0.8.4
	curl-sys@0.4.70+curl-8.5.0
	cxx-build@1.0.111
	cxx@1.0.111
	cxxbridge-flags@1.0.111
	cxxbridge-macro@1.0.111
	errno-dragonfly@0.1.2
	errno@0.3.3
	fastrand@2.0.1
	fnv@1.0.7
	form_urlencoded@1.2.1
	getrandom@0.2.10
	gettext-rs@0.7.0
	gettext-sys@0.21.3
	gimli@0.28.0
	iana-time-zone-haiku@0.1.2
	iana-time-zone@0.1.57
	idna@0.5.0
	js-sys@0.3.64
	lazy_static@1.4.0
	lexopt@0.3.0
	libc@0.2.151
	libm@0.2.7
	libz-sys@1.1.12
	link-cplusplus@1.0.9
	linux-raw-sys@0.4.10
	locale_config@0.3.0
	log@0.4.20
	malloc_buf@0.0.6
	md5@0.7.0
	memchr@2.6.3
	minimal-lexical@0.2.1
	miniz_oxide@0.7.1
	natord@1.0.9
	nom@7.1.3
	num-traits@0.2.16
	objc-foundation@0.1.1
	objc@0.2.7
	objc_id@0.1.1
	object@0.32.1
	once_cell@1.18.0
	percent-encoding@2.3.1
	pkg-config@0.3.27
	ppv-lite86@0.2.17
	proc-macro2@1.0.67
	proptest@1.2.0
	quick-error@1.2.3
	quote@1.0.33
	rand@0.8.5
	rand_chacha@0.3.1
	rand_core@0.6.4
	rand_xorshift@0.3.0
	redox_syscall@0.4.1
	regex-automata@0.3.8
	regex-syntax@0.6.29
	regex-syntax@0.7.5
	regex@1.9.5
	rustc-demangle@0.1.23
	rustix@0.38.21
	rusty-fork@0.3.0
	scratch@1.0.7
	section_testing@0.0.5
	syn@2.0.37
	temp-dir@0.1.11
	tempfile@3.8.1
	termcolor@1.3.0
	tinyvec@1.6.0
	tinyvec_macros@0.1.1
	unarray@0.1.4
	unicode-bidi@0.3.13
	unicode-ident@1.0.12
	unicode-normalization@0.1.22
	unicode-width@0.1.11
	url@2.5.0
	vcpkg@0.2.15
	wait-timeout@0.2.0
	wasi@0.11.0+wasi-snapshot-preview1
	wasm-bindgen-backend@0.2.87
	wasm-bindgen-macro-support@0.2.87
	wasm-bindgen-macro@0.2.87
	wasm-bindgen-shared@0.2.87
	wasm-bindgen@0.2.87
	winapi-i686-pc-windows-gnu@0.4.0
	winapi-util@0.1.6
	winapi-x86_64-pc-windows-gnu@0.4.0
	winapi@0.3.9
	windows-sys@0.48.0
	windows-targets@0.48.5
	windows@0.48.0
	windows_aarch64_gnullvm@0.48.5
	windows_aarch64_msvc@0.48.5
	windows_i686_gnu@0.48.5
	windows_i686_msvc@0.48.5
	windows_x86_64_gnu@0.48.5
	windows_x86_64_gnullvm@0.48.5
	windows_x86_64_msvc@0.48.5
	xdg@2.5.2
"

inherit cargo flag-o-matic toolchain-funcs xdg

DESCRIPTION="An RSS/Atom feed reader for text terminals"
HOMEPAGE="https://newsboat.org/ https://github.com/newsboat/newsboat"
SRC_URI="
	https://newsboat.org/releases/${PV}/${P}.tar.xz
	https://github.com/zlamas/newsboat-docs/archive/refs/tags/${PV}.tar.gz -> ${P}-docs.tar.gz
	${CARGO_CRATE_URIS}
"

LICENSE="Apache-2.0 Boost-1.0 CC-BY-4.0 MIT"
# Dependent crate licenses
LICENSE+=" Unicode-DFS-2016"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~ppc64 x86"

COMMON_DEPEND="
	>=dev-db/sqlite-3.5:3
	>=dev-libs/json-c-0.11:=
	>=dev-libs/stfl-0.21
	>=net-misc/curl-7.32.0[ssl]
	dev-libs/libxml2
	sys-libs/ncurses:=[unicode(+)]
"
# Depend on new enough OpenSSL/GnuTLS libs to avoid providing header files of
# curl's default SSL backend in DEPEND. SSL libs are only called through
# libcurl, so don't depend on any slot.
RDEPEND="${COMMON_DEPEND}
	|| (
		>=dev-libs/openssl-1.1.0:*
		>=net-libs/gnutls-2.11.0:*
		net-libs/mbedtls:*
		net-libs/rustls-ffi:*
	)
"
DEPEND="${COMMON_DEPEND}
	sys-libs/zlib
"
BDEPEND="
	app-alternatives/awk
	sys-devel/gettext
	virtual/pkgconfig
	>=virtual/rust-1.74.0
"

src_prepare() {
	default

	sed -i \
		-e "s/WARNFLAGS=-Werror -Wall/WARNFLAGS=-Wall/" \
		-e "s/BARE_CXXFLAGS=-std=c++11 -O2 -ggdb/BARE_CXXFLAGS=-std=c++11/" \
		-e "s#^doc: .*#doc: doc/example-config#" \
		Makefile || die

	# Avoid running `curl-config` which does not work when cross-compiling.
	# Don't define the HAVE_{OPENSSL,GCRYPT} macros, since they only guard code
	# for older lib versions.
	sed -i -e "s/^check_ssl_implementation$//g" config.sh || die

	local docdir="${WORKDIR}/${PN}-docs-${PV}"
	mkdir doc/xhtml || die
	mv "${docdir}"/*.1 doc || die
	mv "${docdir}"/*.html doc/xhtml || die
}

src_configure() {
	# bug #877657
	if tc-is-gcc ; then
		filter-lto
	fi

	# Set up CXXFLAGS_FOR_BUILD among other (standard) env vars.
	tc-export_build_env AR {BUILD_,}CXX PKG_CONFIG RANLIB
	export CXX_FOR_BUILD="${BUILD_CXX}"
	emake config
}

src_compile() {
	default
}

src_test() {
	export TMPDIR="${T}"
	default
}

src_install() {
	emake DESTDIR="${D}" prefix="${EPREFIX}/usr" docdir="${EPREFIX}/usr/share/doc/${PF}" install
}
