# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Binary I/O stream class library"
HOMEPAGE="http://libbinio.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ~mips ppc ppc64 sparc x86"
IUSE="static-libs"

RDEPEND=""
DEPEND="sys-apps/texinfo"

PATCHES=(
	"${FILESDIR}"/${P}-cstdio.patch
	"${FILESDIR}"/${P}-texi.patch
)

src_configure() {
	econf $(use_enable static-libs static)
}

src_install() {
	default

	# package provides .pc files
	find "${D}" -name '*.la' -delete || die
}
