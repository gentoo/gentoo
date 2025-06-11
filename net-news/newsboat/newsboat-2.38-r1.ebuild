# Copyright 2017-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES=""
RUST_MIN_VER="1.74.1"

inherit cargo flag-o-matic toolchain-funcs xdg

DESCRIPTION="An RSS/Atom feed reader for text terminals"
HOMEPAGE="https://newsboat.org/ https://github.com/newsboat/newsboat"
SRC_URI="
	https://newsboat.org/releases/${PV}/${P}.tar.xz
	https://dev.gentoo.org/~arthurzam/distfiles/net-news/${PN}/${P}-crates.tar.xz
	!doc? ( https://dev.gentoo.org/~arthurzam/distfiles/net-news/${PN}/${P}-docs.tar.xz )
"

LICENSE="Apache-2.0 Boost-1.0 CC-BY-4.0 MIT"
# Dependent crate licenses
LICENSE+=" Apache-2.0 CC0-1.0 MIT Unicode-3.0 Unicode-DFS-2016 ZLIB"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~x86"
IUSE="doc"

COMMON_DEPEND="
	>=dev-db/sqlite-3.5:3
	>=dev-libs/json-c-0.11:=
	>=dev-libs/stfl-0.21
	>=net-misc/curl-7.32.0[ssl]
	dev-libs/libxml2:=
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
	doc? (
		dev-ruby/asciidoctor
	)
"

src_prepare() {
	default

	sed -i \
		-e "s/WARNFLAGS=-Werror -Wall/WARNFLAGS=-Wall/" \
		-e "s/BARE_CXXFLAGS=-std=c++11 -O2 -ggdb/BARE_CXXFLAGS=-std=c++11/" \
		Makefile || die

	# Avoid running `curl-config` which does not work when cross-compiling.
	# Don't define the HAVE_{OPENSSL,GCRYPT} macros, since they only guard code
	# for older lib versions.
	sed -i -e "s/^check_ssl_implementation$//g" config.sh || die

	if use !doc; then
		sed -i Makefile -e "s#^doc: .*#doc: doc/example-config#" || die
	fi
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
