# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

MY_P="Geramik-${PV}"
DESCRIPTION="GTK+1 and GTK+2 Geramik Themes"
HOMEPAGE="http://www.kde-look.org/content/show.php?content=3952"
SRC_URI="http://www.kde-look.org/content/files/3952-${MY_P}.tar.gz"

KEYWORDS="alpha amd64 ~mips ~ppc sparc x86"
LICENSE="GPL-2"
SLOT="0"
IUSE=""

DEPEND=""
RDEPEND="x11-themes/gtk-engines-qtpixmap"

S=${WORKDIR}/${MY_P}

src_install() {
	make DESTDIR="${D}" install || die "Installation failed"

	dodoc AUTHORS ChangeLog README TODO
}
