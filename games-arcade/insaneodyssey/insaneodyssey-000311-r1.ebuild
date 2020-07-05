# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools desktop

DESCRIPTION="Help West Muldune escape from a futuristic mental hospital"
HOMEPAGE="http://members.fortunecity.com/rivalentertainment/iox.html"
# Upstream has download issues.
#SRC_URI="http://members.fortunecity.com/rivalentertainment/io${PV}.tar.gz"
SRC_URI="mirror://gentoo/io${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="
	media-libs/libsdl[sound,video]
	media-libs/sdl-mixer
	media-libs/sdl-image"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}"

PATCHES=(
	# Modify data load code and paths to game data
	"${FILESDIR}"/${P}-datafiles.patch
	"${FILESDIR}"/${P}-gcc6.patch
)

src_prepare() {
	default

	sed -i \
		-e "/lvl/s:^:/usr/share/${PN}/:" \
		-e "s:night:/usr/share/${PN}/night:" \
		insaneodyssey/levels.dat || die
	sed -i \
		-e "s:tiles.dat:/usr/share/${PN}/tiles.dat:" \
		-e "s:sprites.dat:/usr/share/${PN}/sprites.dat:" \
		-e "s:levels.dat:/usr/share/${PN}/levels.dat:" \
		-e "s:IO_T:/usr/share/${PN}/IO_T:" \
		-e "s:tiles.att:/usr/share/${PN}/tiles.att:" \
		-e "s:shot:/usr/share/${PN}/shot:" \
		insaneodyssey/io.cpp || die
	sed -i \
		-e 's:\[32:[100:' \
		insaneodyssey/io.h || die

	mv configure.{in,ac} || die
	eautoreconf
}

src_install() {
	cd insaneodyssey || die

	dobin insaneodyssey

	insinto /usr/share/insaneodyssey
	doins *bmp *png *dat *att *lvl *wav *mod *IT

	newicon west00r.png insaneodyssey.png
	make_desktop_entry insaneodyssey "Insane Odyssey"
}
