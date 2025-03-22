# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="Multiplayer, networked game of little tanks with really big weapons"
HOMEPAGE="https://www.nongnu.org/koth/"
SRC_URI="https://savannah.nongnu.org/download/${PN}/default.pkg/${PV}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="media-libs/libggi"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}"/${P}-autotools.patch
	"${FILESDIR}"/${P}-gcc.patch
	"${FILESDIR}"/${P}-lto.patch
)

src_prepare() {
	default

	eautoreconf
}

src_install() {
	default
	dodoc doc/*.txt

	insinto /etc/koth
	doins src/koth.cfg
}
