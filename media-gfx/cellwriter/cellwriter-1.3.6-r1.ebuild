# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit xdg

DESCRIPTION="Grid-entry natural handwriting input panel"
HOMEPAGE="http://risujin.org/cellwriter/"
SRC_URI="https://github.com/risujin/cellwriter/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"

RDEPEND="x11-libs/gtk+:2
	x11-libs/libX11
	x11-libs/libXtst"
DEPEND="${RDEPEND}
	x11-base/xorg-proto"
BDEPEND="virtual/pkgconfig"

DOCS="AUTHORS ChangeLog README TODO" # NEWS is no-op

PATCHES=(
	"${FILESDIR}/${PN}-1.3.6-fno-common.patch"
	"${FILESDIR}/${PN}-1.3.6-gcc15.patch"
)

src_prepare() {
	default

	sed -i -e '/Encoding/d' ${PN}.desktop || die
}
