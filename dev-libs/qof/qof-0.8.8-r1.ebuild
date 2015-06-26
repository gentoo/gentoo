# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/qof/qof-0.8.8-r1.ebuild,v 1.3 2015/06/26 09:21:27 ago Exp $

EAPI=5
GCONF_DEBUG="no"
GNOME2_LA_PUNT="yes"

inherit autotools eutils gnome2

DESCRIPTION="A Query Object Framework"
HOMEPAGE="https://alioth.debian.org/projects/qof/"
SRC_URI="mirror://debian//pool/main/q/${PN}/${PN}_${PV}.orig.tar.gz"
LICENSE="GPL-2"

SLOT="2"
KEYWORDS="amd64 ~ppc ~ppc64 ~sparc x86"
IUSE="doc nls"

RDEPEND="
	dev-libs/libxml2
	dev-libs/glib:2
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	virtual/yacc
	>=sys-devel/gettext-0.19.2
	!dev-libs/qof:0
	doc? (
		app-doc/doxygen
		dev-texlive/texlive-latex )
"

src_prepare() {
	# Remove some CFLAGS
	epatch "${FILESDIR}"/${PN}-0.8.8-cflags.patch

	# Delay build of unittests, bug #197999
	epatch "${FILESDIR}"/${PN}-0.8.8-unittest.patch

	# Fix use and build with yacc
	epatch "${FILESDIR}"/${PN}-0.8.8-unistd-define.patch
	epatch "${FILESDIR}"/${PN}-0.8.8-yacc-build.patch
	rm lib/libsql/{lexer.c,parser.c,parser.h} || die

	eautoreconf
	gnome2_src_prepare
}

src_configure() {
	gnome2_src_configure \
		--disable-error-on-warning \
		--disable-static \
		--disable-gdasql \
		--disable-gdabackend \
		--disable-sqlite \
		$(use_enable nls) \
		$(use_enable doc doxygen) \
		$(use_enable doc latex-docs) \
		$(use_enable doc html-docs)
}
