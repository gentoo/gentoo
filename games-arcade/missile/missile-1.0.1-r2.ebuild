# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop flag-o-matic toolchain-funcs

DESCRIPTION="Port of the Atari Missile Command game for Linux"
HOMEPAGE="https://missile.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+sound"

RDEPEND="
	media-libs/libsdl[sound?,video]
	media-libs/sdl-image[png]
	sound? ( media-libs/sdl-mixer )"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

src_compile() {
	tc-export CC

	local cppargs=(
		-DDATA="'\"${EPREFIX}/usr/share/${PN}\"'"
		-DVERSION=\\\"${PV}\\\"
		$(usev sound -DUSE_SOUND)
		$($(tc-getPKG_CONFIG) --cflags sdl SDL_image $(usev sound SDL_mixer))
	)
	append-cppflags "${cppargs[@]}"

	LDLIBS="$($(tc-getPKG_CONFIG) --libs sdl SDL_image $(usev sound SDL_mixer)) -lm" \
		emake -f /dev/null ${PN}
}

src_install() {
	dobin ${PN}

	insinto /usr/share/${PN}
	doins -r data/{graphics,missile_icon.png,sound}

	einstalldocs

	newicon icons/${PN}_icon_red.png ${PN}.png
	make_desktop_entry ${PN} "Missile Command"
}
