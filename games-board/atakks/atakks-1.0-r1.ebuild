# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit eutils

MY_P=${P/-/_}
DESCRIPTION="A clone of Ataxx"
HOMEPAGE="http://team.gcu-squad.org/~fab"
# no version upstream
#SRC_URI="http://team.gcu-squad.org/~fab/down/${PN}.tgz"
SRC_URI="mirror://gentoo/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

DEPEND="media-libs/libsdl:0"
RDEPEND=${DEPEND}

S=${WORKDIR}/${MY_P}

PATCHES=(
	"${FILESDIR}"/${PV}-warnings.patch
	"${FILESDIR}"/${P}-as-needed.patch
)

src_prepare() {
	default

	# Modify game data paths
	sed -i \
		-e "s:SDL_LoadBMP(\":SDL_LoadBMP(\"/usr/share/${PN}/:" \
		main.c || die
}

src_compile() {
	emake E_CFLAGS="${CFLAGS}"
}

src_install() {
	dobin ${PN}
	insinto /usr/share/${PN}
	doins *bmp
	newicon icon.bmp ${PN}.bmp
	make_desktop_entry ${PN} Atakks /usr/share/pixmaps/${PN}.bmp
}
