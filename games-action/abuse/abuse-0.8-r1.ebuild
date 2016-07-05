# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit autotools

DESCRIPTION="Port of Abuse by Crack Dot Com"
HOMEPAGE="http://abuse.zoy.org/"
SRC_URI="http://abuse.zoy.org/raw-attachment/wiki/download/${P}.tar.gz"

LICENSE="GPL-2 WTFPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

DEPEND=">=media-libs/libsdl-1.1.6[sound,opengl,video]
	media-libs/sdl-mixer
	virtual/opengl"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}"/${P}-gentoo.patch
)

src_prepare() {
	default
	eautoreconf
}

src_install() {
	# Source-based install
	default

	doicon doc/${PN}.png
	make_desktop_entry abuse Abuse
}

pkg_postinst() {
	elog "NOTE: If you had previous version of abuse installed"
	elog "you may need to remove ~/.abuse for the game to work correctly."
}
