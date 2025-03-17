# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop toolchain-funcs

DESCRIPTION="A game like Deflektor (C 64) or Mindbender (Amiga)"
HOMEPAGE="https://www.artsoft.org/mirrormagic/"
SRC_URI="https://www.artsoft.org/RELEASES/linux/mirrormagic/${P}-linux.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	media-libs/libsdl2[video]
	media-libs/sdl2-image
	media-libs/sdl2-mixer
	media-libs/sdl2-net
"
DEPEND="${RDEPEND}"

src_prepare() {
	default
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
		BASE_PATH="${EPREFIX}/usr/share/${PN}" \
		PROGBASE=${PN} \
		TARGET=sdl2
}

src_install() {
	dobin ${PN}
	insinto /usr/share/${PN}
	doins -r graphics levels music sounds
	doicon "${FILESDIR}"/${PN}.xpm
	make_desktop_entry ${PN} "Mirror Magic II"
	einstalldocs
}
