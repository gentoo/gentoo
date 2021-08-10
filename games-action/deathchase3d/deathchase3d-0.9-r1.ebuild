# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="A remake of the Sinclair Spectrum game of the same name"
HOMEPAGE="http://www.autismuk.freeserve.co.uk/"
SRC_URI="http://www.autismuk.freeserve.co.uk/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="media-libs/libsdl[video]"
RDEPEND=${DEPEND}

PATCHES=(
	"${FILESDIR}/${P}-underlink.patch"
)

src_install() {
	dobin "${PN}/${PN}"
	dodoc README ${PN}/docs/en/index.html
}
