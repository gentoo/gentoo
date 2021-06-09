# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop toolchain-funcs

MY_P="${P/-/_}"
DESCRIPTION="Clone of Ataxx"
HOMEPAGE="http://team.gcu-squad.org/~fab"
# no version upstream
#SRC_URI="http://team.gcu-squad.org/~fab/down/${PN}.tgz"
SRC_URI="mirror://gentoo/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="media-libs/libsdl:0"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}"

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
	tc-export CC
	emake E_CFLAGS="${CFLAGS}"
}

src_install() {
	dobin ${PN}
	insinto /usr/share/${PN}
	doins *bmp
	newicon icon.bmp ${PN}.bmp
	make_desktop_entry ${PN} Atakks /usr/share/pixmaps/${PN}.bmp
}
