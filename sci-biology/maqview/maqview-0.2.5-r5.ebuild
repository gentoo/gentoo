# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="GUI for sci-biology/maq, a short read mapping assembler"
HOMEPAGE="https://maq.sourceforge.net/"
SRC_URI="https://downloads.sourceforge.net/maq/${P}.tar.gz"
S="${WORKDIR}/${PN}"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="
	media-libs/freeglut
	sys-libs/zlib"
RDEPEND="${DEPEND}
	sci-biology/maq"

PATCHES=(
	"${FILESDIR}"/${PV}-ldflags.patch
	"${FILESDIR}"/${PV}-zlib.patch
	"${FILESDIR}"/${P}-gcc4.7.patch
	"${FILESDIR}"/${P}-gcc14-build-fix.patch
)

src_prepare() {
	default
	eautoreconf
}
