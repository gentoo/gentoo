# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit desktop

DESCRIPTION="A puzzle game inspired by Albert Einstein"
HOMEPAGE="https://github.com/lksj/einstein-puzzle"
SRC_URI="https://github.com/lksj/einstein-puzzle/archive/v${PV}.tar.gz -> ${P}.tar.gz
	mirror://gentoo/${PN}.png"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="media-libs/libsdl[sound,video]
	media-libs/sdl-mixer
	media-libs/sdl-ttf"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}-puzzle-${PV}"

src_prepare() {
	default
	eapply "${FILESDIR}"/${PN}-2.0-as-needed.patch
	sed -i \
		-e "/PREFIX/s:/usr/local:/usr:" \
		-e "s/\(OPTIMIZE=[^#]*\)/\0 ${CXXFLAGS}/" Makefile \
		|| die
}

src_install() {
	dobin "${PN}"
	insinto "/usr/share/${PN}/res"
	doins einstein.res
	doicon "${DISTDIR}"/${PN}.png
	make_desktop_entry ${PN} "Einstein Puzzle"
	einstalldocs
}
