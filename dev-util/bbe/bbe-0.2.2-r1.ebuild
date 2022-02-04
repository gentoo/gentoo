# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="Sed-like editor for binary files"
HOMEPAGE="https://sourceforge.net/projects/bbe-/"
SRC_URI="mirror://sourceforge/${PN}-/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm x86 ~amd64-linux ~x86-linux"
IUSE=""

PATCHES=(
	"${FILESDIR}"/bbe-0.2.2-inline.patch
)

src_prepare() {
	default

	sed -i -e '/^htmldir/d' doc/Makefile.am || die
	eautoreconf
}
