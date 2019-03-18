# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

GNOME2_EAUTORECONF="yes"
inherit gnome2

DESCRIPTION="Menu editor for Enlightenment DR16 written in GTK2"
HOMEPAGE="https://www.enlightenment.org https://sourceforge.net/projects/enlightenment/"
SRC_URI="mirror://sourceforge/enlightenment/${P}.tar.gz"
KEYWORDS="~amd64 ~x86"

LICENSE="MIT-with-advertising"
SLOT="0"

BDEPEND="
	virtual/pkgconfig
"
DEPEND="
	>=gnome-base/libglade-2.4
	x11-libs/gtk+:2
	x11-wm/e16
"
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}/${PN}-no-default-docs.patch" )

src_prepare() {
	sed -i '1i#include <glib/gstdio.h>' src/e16menuedit2.c || die
	gnome2_src_prepare
}
