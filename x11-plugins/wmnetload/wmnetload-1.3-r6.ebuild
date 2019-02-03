# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="Network interface monitor dockapp"
HOMEPAGE="https://github.com/bbidulock/wmnetload"
SRC_URI="https://github.com/bbidulock/wmnetload/releases/download/${PV}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"

DEPEND=">=x11-libs/libdockapp-0.7:="
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}/${P}-r4-configure.patch" )

src_prepare() {
	default
	sed -e 's#<dockapp.h>#<libdockapp/dockapp.h>#' -i src/*.c || die
	eautoreconf
}
