# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

MY_P="5507-Golden-XCursors-3D-${PV}"
DESCRIPTION="A high quality set of Xfree 4.3.0 animated mouse cursors"
HOMEPAGE="http://www.kde-look.org/content/show.php?content=5507"
SRC_URI="http://www.kde-look.org/content/files/$MY_P.tar.bz2"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha amd64 hppa ia64 ~mips ppc ppc64 sparc x86"

S=${WORKDIR}/${MY_P:5}

src_install() {
	dodir /usr/share/cursors/xorg-x11/Gold/cursors/
	cp -R Gold/cursors "${D}"/usr/share/cursors/xorg-x11/Gold/ || die
	dodoc README "${FILESDIR}"/README.gentoo
}
