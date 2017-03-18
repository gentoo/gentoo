# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils toolchain-funcs

MY_DATA_V="2005-12-21"
MY_DATA_P="${PN}data-${MY_DATA_V}"
DESCRIPTION="Worms of Prey - A multi-player, real-time clone of Worms"
HOMEPAGE="http://wormsofprey.org/"
SRC_URI="http://wormsofprey.org/download/${P}-src.tar.bz2
	http://wormsofprey.org/download/${MY_DATA_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~x86-fbsd"
IUSE=""

RDEPEND="media-libs/libsdl
	media-libs/sdl-image
	media-libs/sdl-mixer
	media-libs/sdl-net
	media-libs/sdl-ttf"
DEPEND="${RDEPEND}
	x11-misc/makedepend"

MY_DATA_S=${WORKDIR}/${MY_DATA_P}

PATCHES=(
	"${FILESDIR}"/${P}-Makefile.patch
	"${FILESDIR}"/${P}-gcc43.patch
	"${FILESDIR}"/${P}-gcc6.patch
)

src_prepare() {
	default

	# patch global woprc with the correct data files location and install it
	sed -i \
		-e "s:^data =.*$:data = /usr/share/${PN}:" \
		woprc \
		|| die "sed failed"
}

src_compile() {
	emake CXX=$(tc-getCXX)
}

src_install() {
	dobin bin/${PN}
	insinto /usr/share/${PN}
	doins -r "${MY_DATA_S}"/.
	insinto /etc
	doins woprc
	newicon "${MY_DATA_S}"/images/misc/icons/wop16.png ${PN}.png
	make_desktop_entry wop "Worms of Prey"
	dodoc AUTHORS ChangeLog README{,-Libraries.txt} REVIEWS
}
