# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="Network interface monitor dockapp"
HOMEPAGE="https://github.com/bbidulock/wmnetload"
SRC_URI="https://github.com/bbidulock/wmnetload/releases/download/${PV}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"

DEPEND=">=x11-libs/libdockapp-0.7:="
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}/${P}-r4-configure.patch"
	"${FILESDIR}/${P}-C23.patch"
)

src_prepare() {
	default

	eautoreconf
}
