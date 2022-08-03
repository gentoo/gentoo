# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit flag-o-matic xdg

DESCRIPTION="Fast paced, arcade-style, top-scrolling space shooter"
HOMEPAGE="https://chromium-bsu.sourceforge.io"
SRC_URI="mirror://sourceforge/chromium-bsu/${P}.tar.gz"

LICENSE="Clarified-Artistic"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="openal"

RDEPEND="
	media-libs/libsdl2[joystick,opengl,video]
	media-libs/quesoglc
	media-libs/sdl2-image[png]
	virtual/glu
	virtual/libintl
	virtual/opengl
	openal? (
		media-libs/freealut
		media-libs/openal
	)
	!openal? (
		media-libs/libsdl2[sound]
		media-libs/sdl2-mixer
	)"
DEPEND="${RDEPEND}"
BDEPEND="sys-devel/gettext"

src_configure() {
	append-cppflags -DWITH_JOYSTICK

	local econfargs=(
		$(use_enable openal)
		--docdir="${EPREFIX}"/usr/share/${PF}/html

		# there's other build-time alternatives but most are deprecated/dead
		# or with some issues, simply stick to the newly added SDL2 support
		--disable-{ftgl,glpng,glut,sdl,sdlimage,sdlmixer}
	)
	econf "${econfargs[@]}"
}

src_compile() {
	emake LDFLAGS="${LDFLAGS}"
}
