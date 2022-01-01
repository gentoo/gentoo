# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_P="5533-Silver-XCursors-3D-${PV}"

DESCRIPTION="A high quality set of animated mouse cursors"
HOMEPAGE="https://store.kde.org/p/999966/"
SRC_URI="mirror://gentoo/$MY_P.tar.bz2"
S="${WORKDIR}/${MY_P:5}"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ppc ~ppc64 ~s390 sparc x86"

RDEPEND="x11-libs/libXcursor"

src_install() {
	insinto /usr/share/cursors/xorg-x11/Silver/cursors
	doins -r Silver/cursors
	dodoc README "${FILESDIR}"/README.gentoo
}
