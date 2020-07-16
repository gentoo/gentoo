# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="for mjpegtools for adding subtitles, pictures & effects embedded in the picture"
HOMEPAGE="http://panteltje.com/panteltje/subtitles/"
SRC_URI="mirror://gentoo/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"

RDEPEND="
	x11-libs/libX11
	x11-libs/libXaw
	x11-libs/libXt"
DEPEND="${RDEPEND}"

PATCHES=( "${FILESDIR}"/${P}-fix-build-system.patch )

src_configure() {
	tc-export CC
}

src_install() {
	dobin ${PN}
	einstalldocs
	dodoc HOWTO_USE_THIS

	insinto /usr/share/${PN}
	doins *.{ppm,ppml,zip}
}
