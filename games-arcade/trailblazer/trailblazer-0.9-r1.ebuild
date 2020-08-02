# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="Guide a ball through a succession of levels while avoiding holes"
HOMEPAGE="http://www.autismuk.freeserve.co.uk/"
SRC_URI="http://www.autismuk.freeserve.co.uk/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="media-libs/libsdl[video]"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}"/${P}-gentoo-fhs.patch
	"${FILESDIR}"/${P}-makefile.patch
)

src_configure() {
	tc-export CC
}

src_install() {
	dobin trailblazer
	dodoc README

	insinto /usr/share/${PN}
	doins trail.dat

	dodir /var/trailblazer
	touch "${ED}"/var/trailblazer/trail.time
	fperms 660 /var/trailblazer/trail.time
}
