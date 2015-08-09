# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
GCONF_DEBUG="yes"
GNOME_TARBALL_SUFFIX="bz2"

inherit autotools gnome2 eutils

DESCRIPTION="Typesafe callback system for standard C++"
HOMEPAGE="http://libsigc.sourceforge.net/"

LICENSE="GPL-2 LGPL-2.1+"
SLOT="1.2"
KEYWORDS="alpha amd64 arm hppa ia64 ppc ppc64 sh sparc x86"
IUSE=""

DEPEND="sys-devel/m4"
RDEPEND=""

src_prepare() {
	DOCS="AUTHORS ChangeLog FEATURES IDEAS README NEWS TODO"

	# fixes bug #219041
	sed -e 's:ACLOCAL_AMFLAGS = -I $(srcdir)/scripts:ACLOCAL_AMFLAGS = -I scripts:' \
		-i Makefile.{in,am}

	# fixes bug #469698
	sed -e 's:AM_CONFIG_HEADER:AC_CONFIG_HEADERS:g' -i configure.in || die

	# Fix duplicated file installation, bug #346949
	epatch "${FILESDIR}/${P}-fix-install.patch"

	eautoreconf
	gnome2_src_prepare
}

src_configure() {
	gnome2_src_configure \
		--enable-maintainer-mode \
		--enable-threads
}
