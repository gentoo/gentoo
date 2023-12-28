# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="Mifare Classic Offline Cracker"
HOMEPAGE="https://github.com/nfc-tools/mfoc"
SRC_URI="https://github.com/nfc-tools/${PN}/archive/${P}.tar.gz"
S="${WORKDIR}/${PN}-${P}"

LICENSE="GPL-2 GPL-2+ BSD-2"
SLOT="0"
KEYWORDS="~amd64"

DEPEND=">=dev-libs/libnfc-1.7.0:="
RDEPEND="${DEPEND}"

src_prepare() {
	default
	eautoreconf
}
