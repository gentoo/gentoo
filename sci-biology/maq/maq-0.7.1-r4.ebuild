# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="Mapping and Assembly with Qualities, mapping NGS reads to reference genomes"
HOMEPAGE="https://maq.sourceforge.net/"
SRC_URI="
	https://downloads.sourceforge.net/${PN}/${P}.tar.bz2
	https://downloads.sourceforge.net/${PN}/calib-36.dat.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="virtual/zlib:="
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${P}-flags.patch
	"${FILESDIR}"/${P}-bfr-overfl.patch
	"${FILESDIR}"/${P}-gcc-4.7.patch
	"${FILESDIR}"/${P}-remove-64bit-flag.patch
	"${FILESDIR}"/${P}-gcc14-build-fix.patch
)

src_prepare() {
	default
	eautoreconf
}

src_install() {
	default

	insinto /usr/share/maq
	doins "${WORKDIR}"/*.dat

	doman maq.1
	dodoc maq.pdf
}
