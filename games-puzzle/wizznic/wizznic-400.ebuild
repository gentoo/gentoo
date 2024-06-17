# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop toolchain-funcs xdg

DESCRIPTION="Block-clearing puzzle game"
HOMEPAGE="http://wizznic.org/"
SRC_URI="https://downloads.sourceforge.net/wizznic/Wizznic_src_build_${PV}.tar.bz2"
S="${WORKDIR}/Wizznic_src_build_${PV}"
LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="opengl"

DEPEND="
	media-libs/libsdl[sound,joystick,opengl?,video]
	media-libs/sdl-image[png]
	media-libs/sdl-mixer[vorbis]
	opengl? ( media-libs/libglvnd[X] )
"

RDEPEND="
	${DEPEND}
"

src_compile() {
	emake -f Makefile.linux \
		DATADIR="${EPREFIX}/usr/share/${PN}/" \
		WITH_OPENGL=$(usex opengl true false) \
		CC="$(tc-getCC)" \
		CFLAGS="${CFLAGS} -Wall -std=c99" \
		LDFLAGS="${LDFLAGS}" \
		STRIP=true
}

src_install() {
	emake -f Makefile.linux \
		DESTDIR="${ED}" \
		DATADIR="/usr/share/${PN}/" \
		BINDIR="/usr/bin" \
		install

	dodoc doc/{changelog,credits,media-licenses,ports,readme}.txt
	newicon -s 32 data/wmicon.png ${PN}.png
	make_desktop_entry ${PN} ${PN^}
}
