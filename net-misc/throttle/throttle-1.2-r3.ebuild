# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

# orphaned package, we keep its sources, but upstream is long gone, and
# disappeared

DESCRIPTION="Bandwidth limiting pipe"
HOMEPAGE="https://web.archive.org/web/20110725180344/http://klicman.org/"
SRC_URI="https://dev.gentoo.org/~grobian/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

PATCHES=(
	"${FILESDIR}"/${P}-bool.patch
)

src_prepare() {
	default

	eautoreconf
}
