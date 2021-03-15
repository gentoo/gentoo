# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

MY_P="5533-Silver-XCursors-3D-${PV}"
DESCRIPTION="A high quality set of Xfree 4.3.0 animated mouse cursors"
HOMEPAGE="http://www.kde-look.org/content/show.php?content=5533"
SRC_URI="http://www.kde-look.org/CONTENT/content-files/$MY_P.tar.bz2"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha amd64 ~hppa ~ia64 ~mips ~ppc ~sparc x86"

S="${WORKDIR}/${MY_P:5}"

src_install() {
	dodir /usr/share/cursors/xorg-x11/Silver/cursors/
	cp -R  Silver/cursors "${D}"/usr/share/cursors/xorg-x11/Silver/ || die
	dodoc README "${FILESDIR}"/README.gentoo
}
