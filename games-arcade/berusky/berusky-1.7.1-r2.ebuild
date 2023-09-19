# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop flag-o-matic gnome2

DATAFILE="${PN}-data-1.7"
DESCRIPTION="Free logic game based on an ancient puzzle named Sokoban"
HOMEPAGE="https://anakreon.cz/?q=node/1"
SRC_URI="https://www.anakreon.cz/download/${P}.tar.gz
	https://www.anakreon.cz/download/${DATAFILE}.tar.gz
	https://dev.gentoo.org/~hasufell/distfiles/${PN}.png"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	media-libs/libsdl[X,video]
	media-libs/sdl-image[png]
	x11-libs/gtk+:2
"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${PN}-1.7.1-r2-gentoo.patch
	"${FILESDIR}"/${PN}-1.7.1-missing-includes.patch
)

src_prepare() {
	mv ../${DATAFILE}/{berusky.ini,GameData,Graphics,Levels} . || die

	default
}

src_configure() {
	# https://bugs.gentoo.org/787287
	# clashes with C++17's "std::byte" type
	append-cxxflags -std=c++14

	default
}

src_install() {
	gnome2_src_install

	rm -rf "${ED}"/usr/doc || die

	insinto /usr/share/${PN}
	doins -r GameData Graphics Levels

	insinto /var/lib/${PN}
	doins berusky.ini

	doicon -s 32 "${DISTDIR}"/${PN}.png
	make_desktop_entry ${PN}
}
