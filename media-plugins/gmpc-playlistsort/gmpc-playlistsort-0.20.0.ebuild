# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="This plugin adds a dialog to sort the current playlist"
HOMEPAGE="http://gmpc.wikia.com/"
SRC_URI="mirror://sourceforge/musicpd/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE=""

RDEPEND="
	>=media-sound/gmpc-${PV}
	>=gnome-base/libglade-2
	dev-libs/libxml2:="
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_install() {
	default
	find "${D}" -name '*.la' -delete || die
}
