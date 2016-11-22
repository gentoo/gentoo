# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
WX_GTK_VER="3.0"

inherit vcs-snapshot wxwidgets

DESCRIPTION="Visualization and Audibilization of Sorting Algorithms"
HOMEPAGE="http://panthema.net/2013/sound-of-sorting/ https://github.com/bingmann/sound-of-sorting"
#SRC_URI="http://panthema.net/2013/sound-of-sorting/${P}.tar.bz2"
COMMIT="05db428c796a7006d63efdbe314f976e0aa881d6"
SRC_URI="https://github.com/bingmann/${PN}/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="
	media-libs/libsdl
	x11-libs/wxGTK:${WX_GTK_VER}
"
DEPEND="${RDEPEND}"

src_unpack() {
	vcs-snapshot_src_unpack
	need-wxwidgets unicode
}
