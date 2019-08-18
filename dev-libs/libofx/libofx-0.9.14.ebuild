# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools flag-o-matic

DESCRIPTION="A library to support the Open Financial eXchange XML format"
HOMEPAGE="https://github.com/libofx/libofx"
SRC_URI="https://github.com/${PN}/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~hppa ~x86"
IUSE="static-libs test"

RDEPEND="
	>=net-misc/curl-7.9.7
	virtual/libiconv
"
DEPEND="${RDEPEND}
	>app-text/opensp-1.5
	>=dev-cpp/libxmlpp-2.40.1:2.6
	dev-util/gengetopt
	sys-apps/help2man
	virtual/pkgconfig
	test? ( app-crypt/gnupg )"

# workaround needed for ofxconnect to compile
MAKEOPTS="-j1"

src_prepare() {
	default
	eautoreconf

	# we will tell you where we wants the docs!
	sed -i -e 's:docdir.*::' Makefile.am || die
	sed -i -e 's:docdir.*::' dtd/Makefile.am || die

	# configure arguments alone don't disable everything
	sed -e "/^SUBDIRS/s/doc//" -i Makefile.am || die

	append-cxxflags -std=c++14

	# build will fail without this. shenanigans...
	touch INSTALL || die "failed to touch INSTALL"
}

src_configure() {
	econf --docdir=/usr/share/doc/${PF}
}

src_install() {
	default
	find "${D}" -name '*.la' -delete || die
}
