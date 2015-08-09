# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils autotools

DESCRIPTION="Helper library for the x11-misc/matchbox-keyboard package"
HOMEPAGE="http://matchbox-project.org/"
SRC_URI="http://matchbox-project.org/sources/${PN}/${PV}/${P}.tar.bz2"
LICENSE="GPL-2"
SLOT="0"

KEYWORDS="~amd64 ~arm ~hppa ~ppc ~x86"
IUSE="debug doc"

RDEPEND="x11-libs/libXtst"

DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )"

src_prepare() {
	# Allow configure to use libtool-2
	epatch "${FILESDIR}/${P}-ac.patch"

	# Fix underlinking bug #367595
	sed -i -e 's/^fakekey_test_LDADD=/fakekey_test_LDADD=-lX11 /' \
		tests/Makefile.am || die 'Cannot sed Makefile.am'
	sed -e "s/AM_CONFIG_HEADER/AC_CONFIG_HEADERS/" -i configure.ac || die
	eautoreconf
}

src_configure() {
	# --with/without-x is ignored by configure script and X is used.
	econf	--with-x \
		$(use_enable debug) \
		$(use_enable doc doxygen-docs)
}

src_install() {
	emake DESTDIR="${D}" install

	dodoc AUTHORS ChangeLog INSTALL NEWS README
	use doc && dohtml doc/html/*
}
