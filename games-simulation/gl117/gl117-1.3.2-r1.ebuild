# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop

MY_P="gl-117-${PV}-src"

DESCRIPTION="Action flight simulator"
HOMEPAGE="https://sourceforge.net/projects/gl-117/"
SRC_URI="
	mirror://sourceforge/gl-117/${MY_P}.tar.bz2
	https://dev.gentoo.org/~ionen/distfiles/${PN}.png"
S="${WORKDIR}/${MY_P}"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	media-libs/freeglut
	media-libs/libsdl[joystick,opengl,sound,video]
	media-libs/sdl-mixer[mod]
	virtual/glu
	virtual/opengl"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${P}-mode.patch
)

src_install() {
	default

	doman doc/gl-117.6
	dodoc doc/gl-117.pdf

	doicon "${DISTDIR}"/${PN}.png
	make_desktop_entry gl-117 GL-117
}
