# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit eutils flag-o-matic readme.gentoo-r1

DESCRIPTION="Multiplayer AI script based strategy game"
HOMEPAGE="http://galaxyhack.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2
	mirror://gentoo/${PN}.png"

LICENSE="GPL-2 galaxyhack"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	media-libs/libsdl[video]
	media-libs/sdl-image[png]
	media-libs/sdl-mixer[mod,vorbis]
	>=dev-libs/boost-1.34
"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}/src"

DISABLE_AUTOFORMATTING="yes"
DOC_CONTENTS="
Settings will default to those found in
/usr/share/galaxyhack/settings.dat
Per user settings can be specified by creating
~/.galaxyhack/settings.dat

Additional user submitted fleets can be downloaded from
http://galaxyhack.sourceforge.net/viewfleets.php
"

src_prepare() {
	default
	edos2unix Makefile
	eapply \
		"${FILESDIR}"/${P}-destdirs.patch \
		"${FILESDIR}"/${P}-boost.patch \
		"${FILESDIR}"/${P}-gcc43.patch \
		"${FILESDIR}"/${P}-boost-1.50.patch \
		"${FILESDIR}"/${P}-format.patch \
		"${FILESDIR}"/${P}-gentoo.patch
	sed -i "s:@GAMES_DATADIR@:/usr/share:" \
		Main.cpp || die
	sed -i "/Base data path/s:pwd:/usr/share/${PN}:" \
		../settings.dat || die
}

src_install() {
	dobin "${PN}"
	cd ..
	insinto /usr/share/${PN}
	doins -r fleets gamedata graphics music standardpictures \
		settings.dat
	dodoc readme.txt
	readme.gentoo_create_doc
	doicon "${DISTDIR}"/${PN}.png
	make_desktop_entry ${PN} GalaxyHack
}

pkg_postinst() {
	readme.gentoo_print_elog
}
