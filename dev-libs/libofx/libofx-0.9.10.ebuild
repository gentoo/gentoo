# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit autotools-utils

DESCRIPTION="A library to support the Open Financial eXchange XML format"
HOMEPAGE="http://libofx.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~hppa ~ppc ~ppc64 x86"
IUSE="static-libs test"

RDEPEND="
	>=app-text/opensp-1.5
	dev-cpp/libxmlpp:2.6
	>=net-misc/curl-7.9.7
	virtual/libiconv
"
DEPEND="${RDEPEND}
	sys-apps/help2man
	virtual/pkgconfig
	test? ( app-crypt/gnupg )
"

src_prepare() {
	autotools-utils_src_prepare

	# Be sure DTD gets installed in correct path after redefining docdir in install
	sed -i \
		-e 's:$(DESTDIR)$(docdir):$(DESTDIR)$(LIBOFX_DTD_DIR):' \
		dtd/Makefile.in || die

	# configure arguments alone don't disable everything
	sed -e "/^SUBDIRS/s/doc//" -i Makefile.in || die
}

src_compile() {
	autotools-utils_src_compile CXXFLAGS+=-std=c++11 #566456
}

src_install() {
	autotools-utils_src_install docdir="/usr/share/doc/${PF}"

	rm -f "${ED}"/usr/share/doc/${PF}/{COPYING,INSTALL}
}
