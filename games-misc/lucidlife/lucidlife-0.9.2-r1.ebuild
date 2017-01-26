# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit autotools eutils

DESCRIPTION="A Conway's Life simulator written in GTK+2 - fork from Gtklife"
HOMEPAGE="http://gtk-apps.org/content/show.php/LucidLife?content=130867"
SRC_URI="mirror://gentoo/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="x11-libs/gtk+:2"
DEPEND="${DEPEND}
	dev-util/intltool
	sys-devel/gettext
	virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${P}-gnome-vfs.patch
	"${FILESDIR}"/${P}-underlink.patch
)

src_prepare() {
	default

	eautoreconf
	intltoolize --force --copy --automake || die
}

src_install() {
	emake install \
		desktopdir=/usr/share/applications \
		pixmapdir=/usr/share/pixmaps \
		DESTDIR="${D}"

	dodoc AUTHORS ChangeLog NEWS README TODO
}
