# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Basic CD Player for blackbox wm"
HOMEPAGE="http://tranber1.free.fr/bbcd.html"
SRC_URI="http://tranber1.free.fr/${P}.tar.gz"
LICENSE="GPL-2"

SLOT="0"
KEYWORDS="~amd64 ppc x86"
IUSE=""

RDEPEND="media-libs/libcdaudio
	x11-libs/libX11"
DEPEND="${RDEPEND}
	x11-libs/libXt"

PATCHES=(
	"${FILESDIR}"/${P}_${PV}a.diff
	"${FILESDIR}"/${P}-gcc3.3.patch
	"${FILESDIR}"/${P}-gcc4.3.patch
)

src_install() {
	default
	rm "${ED%/}"/usr/share/bbtools/README.bbcd || die
}
