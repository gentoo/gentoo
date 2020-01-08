# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

# orphaned package, we keep its sources, but upstream is long gone, and
# disappeared

DESCRIPTION="Bandwidth limiting pipe"
HOMEPAGE="https://www.gentoo.org/"
SRC_URI="https://dev.gentoo.org/~grobian/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~x86 ~amd64-linux ~ppc-macos ~x86-macos"
IUSE=""

src_prepare() {
	default

	eautoreconf
}
