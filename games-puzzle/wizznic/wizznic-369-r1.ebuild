# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit desktop

DESCRIPTION="Block-clearing puzzle game"
HOMEPAGE="http://wizznic.org/"
SRC_URI="mirror://sourceforge/wizznic/Wizznic_src_build_${PV}.tar.bz2"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="media-libs/libsdl[sound,joystick,opengl,video]
	media-libs/sdl-image[png]
	media-libs/sdl-mixer[vorbis]
	virtual/opengl"
RDEPEND="${DEPEND}"

S="${WORKDIR}/Wizznic_src_build_${PV}"

src_prepare() {
	default
	sed \
		-e '/^\(CC\|LD\|STRIP\)/d' \
		-e 's/(LD)/(CC)/g' \
		-e '/CFLAGS.*=/d' \
		Makefile.linux > Makefile || die
}

src_compile() {
	emake \
		DATADIR="/usr/share/${PN}/" \
		BINDIR="/usr/bin" \
		STRIP=true
}

src_install() {
	emake \
		DESTDIR="${D}" \
		DATADIR="/usr/share/${PN}/" \
		BINDIR="/usr/bin" \
		install
	dodoc doc/{changelog.txt,credits.txt,media-licenses.txt,ports.txt,readme.txt}
	newicon data/wmicon.png ${PN}.png
	make_desktop_entry wizznic "Wizznic!"
}
