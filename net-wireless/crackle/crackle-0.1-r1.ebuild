# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="Crackle cracks BLE Encryption (AKA Bluetooth Smart)"
HOMEPAGE="http://lacklustre.net/projects/crackle/"
SRC_URI="http://lacklustre.net/projects/crackle/${P}.tgz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="net-libs/libpcap"
RDEPEND="${DEPEND}"

RESTRICT="test"

PATCHES=(
	"${FILESDIR}"/flags.patch
)

src_configure() {
	tc-export CC
}

src_install() {
	dobin crackle
}
