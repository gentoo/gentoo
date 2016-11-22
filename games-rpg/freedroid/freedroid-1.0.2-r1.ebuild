# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit eutils

DESCRIPTION="Freedroid - a Paradroid clone"
HOMEPAGE="http://freedroid.sourceforge.net/"
SRC_URI="mirror://sourceforge/freedroid/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

DEPEND="
	virtual/jpeg:0
	media-libs/libpng:0
	media-libs/libsdl[joystick,sound,video]
	media-libs/libvorbis
	media-libs/sdl-image[jpeg,png]
	media-libs/sdl-mixer[mod,vorbis]
	sys-libs/zlib"
RDEPEND=${DEPEND}

PATCHES=(
	"${FILESDIR}"/${P}-format.patch
)

src_install() {
	default
	find "${D}" -name "Makefile*" -exec rm -f '{}' + || die
	rm -rf "${D}/usr/share/${PN}/"{freedroid.6,mac-osx} || die
	newicon graphics/paraicon.bmp ${PN}.bmp
	make_desktop_entry freedroid Freedroid /usr/share/pixmaps/${PN}.bmp
}
