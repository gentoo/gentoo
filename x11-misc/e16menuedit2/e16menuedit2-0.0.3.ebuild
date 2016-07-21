# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
GCONF_DEBUG="yes"

inherit gnome2 eutils

DESCRIPTION="Menu editor for enlightenment DR16 written in GTK2"
HOMEPAGE="https://www.enlightenment.org/"
SRC_URI="mirror://sourceforge/enlightenment/${P}.tar.gz"

LICENSE="MIT-with-advertising"
SLOT="0"
KEYWORDS="amd64 arm ~ppc sh sparc x86"
IUSE=""

RDEPEND="
	>=x11-wm/enlightenment-0.16
	>=gnome-base/libglade-2.4
	x11-libs/gtk+:2
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
"

src_prepare() {
	epatch "${FILESDIR}"/${P}-no-docs.patch
	sed -i '1i#include <glib/gstdio.h>' src/e16menuedit2.c
	gnome2_src_prepare
}
