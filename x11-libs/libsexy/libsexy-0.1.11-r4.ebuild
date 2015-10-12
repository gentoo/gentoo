# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

AUTOTOOLS_AUTORECONF=true

inherit autotools-utils

DESCRIPTION="Sexy GTK+ Widgets"
HOMEPAGE="http://www.chipx86.com/wiki/Libsexy"
SRC_URI="http://releases.chipx86.com/${PN}/${PN}/${P}.tar.bz2"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sh ~sparc ~x86 ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~x86-solaris"
IUSE="doc static-libs"

RDEPEND=">=dev-libs/glib-2
	>=x11-libs/gtk+-2.20:2
	dev-libs/libxml2
	>=x11-libs/pango-1.4
	>=app-text/iso-codes-0.49"
DEPEND="${RDEPEND}
	>=dev-lang/perl-5
	virtual/pkgconfig
	dev-util/gtk-doc-am
	doc? ( >=dev-util/gtk-doc-1.4 )"

DOCS=( AUTHORS ChangeLog NEWS )

PATCHES=(
	"${FILESDIR}"/${P}-fix-null-list.patch
	"${FILESDIR}"/${P}-pkgconfig-pollution.patch
	)

src_prepare() {
	sed -i \
		-e 's:noinst_PROGRAMS:check_PROGRAMS:' \
		tests/Makefile.am || die

	rm -f acinclude.m4 #420913

	sed \
		-e "s:AM_CONFIG_HEADER:AC_CONFIG_HEADERS:g" \
		-i configure.ac

	autotools-utils_src_prepare
}

src_configure() {
	local myeconfargs=(
		$(use_enable doc gtk-doc)
		--with-html-dir="${EPREFIX}/usr/share/doc/${PF}/html"
	)
	autotools-utils_src_configure
}
