# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit eutils flag-o-matic

DESCRIPTION="Multiplayer, networked game of little tanks with really big weapons"
HOMEPAGE="http://www.nongnu.org/koth/"
SRC_URI="https://savannah.nongnu.org/download/${PN}/default.pkg/${PV}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~x86"
IUSE=""

DEPEND="media-libs/libggi"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}"/${PF}-gcc-3.4.patch
)

src_prepare() {
	default
	sed -i 's:-g -O2::' configure || die
	sed -i 's:(uint16):(uint16_t):' src/gfx.c src/gfx.h || die
	append-cflags -std=gnu89 # build with gcc5 (bug #570730)
}

src_install() {
	DOCS="AUTHORS ChangeLog NEWS README doc/*.txt" \
		default
	dodir /etc/koth
	insinto /etc/koth
	doins src/koth.cfg
}
