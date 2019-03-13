# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit desktop toolchain-funcs

DESCRIPTION="A game like Deflektor (C 64) or Mindbender (Amiga)"
HOMEPAGE="https://www.artsoft.org/mirrormagic/"
SRC_URI="https://www.artsoft.org/RELEASES/unix/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="sdl"

RDEPEND="
	!sdl? ( x11-libs/libX11 )
	sdl? (
		media-libs/libsdl[video]
		media-libs/sdl-mixer
		media-libs/sdl-image
	)
"
DEPEND="${RDEPEND}
	!sdl? ( x11-libs/libXt )
"

src_prepare() {
	default
	eapply \
		"${FILESDIR}"/${P}-gcc41.patch \
		"${FILESDIR}"/${P}-parallel.patch \
		"${FILESDIR}"/${P}-64bit.patch \
		"${FILESDIR}"/${P}-gcc5.patch \
		"${FILESDIR}"/${P}-editor.patch
	rm -f ${PN} || die
}

src_compile() {
	emake \
		-C src \
		CC="$(tc-getCC)" \
		AR="$(tc-getAR)" \
		RANLIB="$(tc-getRANLIB)" \
		OPTIONS="${CFLAGS}" \
		EXTRA_LDFLAGS="${LDFLAGS}" \
		RO_GAME_DIR=/usr/share/${PN} \
		RW_GAME_DIR=/var/${PN} \
		TARGET=$(usex sdl sdl x11)
}

src_install() {
	dobin ${PN}
	insinto /usr/share/${PN}
	doins -r graphics levels music sounds
	doicon "${FILESDIR}"/${PN}.xpm
	make_desktop_entry ${PN} "Mirror Magic II"
	einstalldocs
}
