# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit desktop

DESCRIPTION="a cool Jump'n Run game offering some unique visual effects"
HOMEPAGE="http://homepage.hispeed.ch/loehrer/amph/amph.html"
SRC_URI="http://homepage.hispeed.ch/loehrer/amph/files/${P}.tar.bz2
	http://homepage.hispeed.ch/loehrer/amph/files/${PN}-data-0.8.6.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="media-libs/libsdl[sound,video]
	x11-libs/libXpm"
RDEPEND=${DEPEND}

PATCHES=(
	"${FILESDIR}"/${P}-build.patch
	"${FILESDIR}"/${P}-64bit.patch

	# From Debian:
	"${FILESDIR}"/${P}-no-lxt.patch
	"${FILESDIR}"/${P}-bugs.patch
	"${FILESDIR}"/${P}-missing-headers.patch
	"${FILESDIR}"/${P}-newline.patch
)

src_prepare() {
	default
	sed -i -e '55d' src/ObjInfo.cpp || die
}

src_compile() {
	emake INSTALL_DIR=/usr/share/${PN}
}

src_install() {
	newbin amph ${PN}
	insinto /usr/share/${PN}
	doins -r ../amph/*
	newicon amph.xpm ${PN}.xpm
	make_desktop_entry ${PN} Amphetamine ${PN}
	einstalldocs
}
