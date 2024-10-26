# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop

MY_P=einstein-puzzle-${PV}
DESCRIPTION="A puzzle game inspired by Albert Einstein"
HOMEPAGE="https://github.com/lksj/einstein-puzzle/"
SRC_URI="
	https://github.com/lksj/einstein-puzzle/archive/v${PV}.tar.gz
		-> ${MY_P}.tar.gz
	https://dev.gentoo.org/~mgorny/dist/einstein.png
"
S=${WORKDIR}/${MY_P}

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="
	media-libs/libsdl[sound,video]
	media-libs/sdl-mixer
	media-libs/sdl-ttf
"
RDEPEND="
	${DEPEND}
"

src_prepare() {
	default
	eapply "${FILESDIR}"/${PN}-2.0-as-needed.patch
	sed -i \
		-e "/PREFIX/s:/usr/local:/usr:" \
		-e "s/\(OPTIMIZE=[^#]*\)/\0 ${CXXFLAGS}/" Makefile \
		|| die
}

src_install() {
	dobin einstein
	insinto /usr/share/einstein/res
	doins einstein.res
	doicon "${DISTDIR}"/einstein.png
	make_desktop_entry einstein "Einstein Puzzle"
	einstalldocs
}
