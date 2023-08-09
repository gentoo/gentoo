# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools flag-o-matic

DESCRIPTION="Workspace pager dockapp, particularly useful with the Fluxbox window manager"
HOMEPAGE="http://www.isomedia.com/homes/stevencooper"
SRC_URI="http://www.isomedia.com/homes/stevencooper/files/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~hppa ppc x86"

DEPEND="
	x11-libs/libX11
	x11-libs/libSM
	x11-libs/libICE
"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}/${P}-asneeded.patch"
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	append-cxxflags -std=c++14

	econf --datadir="${EPREFIX}"/usr/share/commonbox
}
