# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop toolchain-funcs

COMMIT="7180612a54b42a5f52e15238d7ddf64f0b879e51"
DESCRIPTION="Trap and capture penguins on Antarctica"
HOMEPAGE="https://mattdm.org/icebreaker/"
SRC_URI="https://github.com/mattdm/icebreaker/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${COMMIT}"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	media-libs/libsdl[video]
	media-libs/sdl-mixer
"

DEPEND="
	${RDEPEND}
"

PATCHES=(
	"${FILESDIR}"/${P}-makefile.patch
)

src_compile() {
	emake \
		prefix="${EPREFIX}"/usr \
		bindir="${EPREFIX}"/usr/bin \
		datadir="${EPREFIX}"/usr/share \
		highscoredir="${EPREFIX}"/var \
		CC="$(tc-getCC)" \
		PKG_CONFIG="$(tc-getPKG_CONFIG)" \
		OPTIMIZE=
}

src_install() {
	emake \
		prefix="${ED}"/usr \
		bindir="${ED}"/usr/bin \
		datadir="${ED}"/usr/share \
		highscoredir="${ED}"/var \
		install

	newicon ${PN}_48.bmp ${PN}.bmp
	make_desktop_entry ${PN} IceBreaker /usr/share/pixmaps/${PN}.bmp
	einstalldocs
}
