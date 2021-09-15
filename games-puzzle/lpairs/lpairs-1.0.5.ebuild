# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop

DESCRIPTION="Classic memory game"
HOMEPAGE="http://lgames.sourceforge.net/LPairs/"
SRC_URI="mirror://sourceforge/lgames/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+sound"

RDEPEND="
	media-libs/libsdl[sound?,video]
	virtual/libintl"
DEPEND="${RDEPEND}"
BDEPEND="sys-devel/gettext"

src_prepare() {
	default

	sed -i '/^inst_dir=/s|/games||' configure || die
}

src_configure() {
	# --enable-sound doesn't enable it, needs to be unspecified
	econf $(usev !sound --disable-sound)
}

src_install() {
	default

	doicon ${PN}.png
	make_desktop_entry ${PN} LPairs
}
