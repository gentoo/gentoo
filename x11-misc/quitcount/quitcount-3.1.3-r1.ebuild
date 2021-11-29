# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit xdg

# The string in SRC_URI doesn't follow standard naming convention
MV="3.1"
DESCRIPTION="A simple applet that shows what you saved since you quit smoking."
HOMEPAGE="http://quitcount.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${MV}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="
	x11-libs/gtk+:3
	>=dev-libs/glib-2.6:2
"
RDEPEND="${DEPEND}"

src_prepare() {
	default
	sed -i '/appdata$/s/appdata$/metainfo/' Makefile.in || die
}
