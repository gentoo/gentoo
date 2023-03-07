# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="CUPS backend for canon printers using proprietary USB over IP BJNP protocol"
HOMEPAGE="https://sourceforge.net/projects/cups-bjnp/"
SRC_URI="mirror://sourceforge/${PN}/${PV}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc ~ppc64 x86"

DEPEND="net-print/cups"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}"/${PN}-2.0.3-configure-clang16.patch
)

src_prepare() {
	default

	# Clang 16
	eautoreconf
}

src_configure() {
	econf --disable-Werror
}
