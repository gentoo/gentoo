# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit eutils

MY_PN=${PN}-rally
MY_P=${MY_PN}-${PV}
DESCRIPTION="Free OpenGL rally car racing game"
HOMEPAGE="http://www.positro.net/trigger/"
SRC_URI="mirror://sourceforge/${MY_PN}/${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

RDEPEND="
	dev-games/physfs
	media-libs/freealut
	media-libs/libsdl
	media-libs/openal
	media-libs/sdl-image[jpeg,png]
	media-libs/sdl-mixer
	virtual/glu
	virtual/opengl"
DEPEND="${RDEPEND}
	dev-util/ftjam"

S=${WORKDIR}/${MY_P}

pkg_setup() {
	# Otherwise build fails with:
	# ...skipped trigger for lack of libpengine.a...
	tc-export AR
}

src_configure() {
	econf --datadir=/usr/share/games/${PN}
}

src_compile() {
	AR="${AR} cru" jam -dx -qa || die

}

src_install() {
	dobin ${PN}
	insinto /usr/share/games/${PN}
	doins -r data/*
	newicon data/textures/life_helmet.png ${PN}.png
	make_desktop_entry ${PN} Trigger
	dodoc doc/*.txt
}

pkg_postinst() {
	elog "After running ${PN} for the first time, a config file is"
	elog "available in ~/.trigger/trigger.config"
}
