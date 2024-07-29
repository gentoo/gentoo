# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit xdg

DESCRIPTION="Grid-entry natural handwriting input panel"
HOMEPAGE="http://risujin.org/cellwriter/"
SRC_URI="https://github.com/risujin/cellwriter/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"

BDEPEND="virtual/pkgconfig"
RDEPEND="x11-libs/gtk+:2
	x11-libs/libX11
	x11-libs/libXtst"
DEPEND="${RDEPEND}
	x11-base/xorg-proto"

DOCS="AUTHORS ChangeLog README TODO" # NEWS is no-op

PATCHES=(
	"${FILESDIR}/${PN}-1.3.6-fno-common.patch"
)

src_prepare() {
	default

	sed -i -e '/Encoding/d' ${PN}.desktop || die
}
