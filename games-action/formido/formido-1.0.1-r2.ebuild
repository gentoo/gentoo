# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop toolchain-funcs

DESCRIPTION="A shooting game in the spirit of Phobia games"
HOMEPAGE="http://www.mhgames.org/oldies/formido/"
SRC_URI="http://noe.falzon.free.fr/prog/${P}.tar.gz
	http://koti.mbnet.fi/lsoft/formido/formido-music.tar.bz2"

LICENSE="GPL-2"
SLOT=0
KEYWORDS="~amd64 ~x86"

DEPEND="media-libs/libsdl[sound,video]
	media-libs/sdl-image
	media-libs/sdl-mixer"
RDEPEND=${DEPEND}

src_unpack() {
	unpack ${P}.tar.gz
	cd "${S}"/data || die
	unpack ${PN}-music.tar.bz2
}

src_prepare() {
	default

	sed -i \
		-e '/^FLAGS=/s:$: $(CXXFLAGS):' \
		Makefile || die
}

src_compile() {
	emake CC="$(tc-getCXX)" \
		CXXFLAGS="${CXXFLAGS}" \
		LINKFLAGS="${LDFLAGS}" \
		DATDIR="${EPREFIX}/usr/share/formido/data" \
		DEFCONFIGDIR="${EPREFIX}/usr/share/formido"
}

src_install() {
	dobin ${PN}
	insinto /usr/share/${PN}
	doins -r ${PN}.cfg data
	newicon data/icon.dat ${PN}.bmp
	make_desktop_entry ${PN} Formido /usr/share/pixmaps/${PN}.bmp
	dodoc README README-1.0.1
}
