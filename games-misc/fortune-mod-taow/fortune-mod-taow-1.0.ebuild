# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
MY_P=fortunes-taow-${PV}
DESCRIPTION="The Art of War Fortune Mod"
HOMEPAGE="http://www.de-brauwer.be/wiki/wikka.php?wakka=TheArtOfWar"
SRC_URI="http://www.de-brauwer.be/wastebasket/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~x86-solaris"
IUSE=""

RDEPEND="games-misc/fortune-mod"

S=${WORKDIR}/${MY_P}

src_install() {
	insinto /usr/share/fortune
	doins taow taow.dat
}
