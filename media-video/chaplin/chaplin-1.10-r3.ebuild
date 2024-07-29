# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="This is a program to raw copy chapters from a dvd using libdvdread"
HOMEPAGE="http://www.lallafa.de/bp/chaplin.html"
SRC_URI="http://www.lallafa.de/bp/files/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE="vcd"

DEPEND=">=media-libs/libdvdread-0.9.4"
RDEPEND="${DEPEND}
	virtual/imagemagick-tools
	media-video/mjpegtools
	vcd? ( media-video/vcdimager )"

S=${WORKDIR}/${PN}

PATCHES=(
	"${FILESDIR}"/${P}-libdvdread-0.9.6.patch
	"${FILESDIR}"/${P}-asneeded.patch
)

src_compile() {
	emake CC="$(tc-getCC)"
}

src_install() {
	dobin chaplin chaplin-genmenu
}
