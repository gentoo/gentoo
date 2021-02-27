# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="A library that measures and reports on packet flows"
HOMEPAGE="https://research.wand.net.nz/software/libflowmanager.php"
SRC_URI="https://research.wand.net.nz/software/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0/3"
KEYWORDS="~amd64 ~x86"

DEPEND=">=net-libs/libtrace-3.0.6"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}"/${PN}-3.0.0-stdint_h.patch
)

src_configure() {
	econf --disable-static
}

src_install() {
	default

	find "${ED}" -name '*.la' -delete || die
}
