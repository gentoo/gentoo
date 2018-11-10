# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools

DESCRIPTION="Wijesekara keyboard for Sinhala input using scim"
HOMEPAGE="http://sinhala.sourceforge.net/"
SRC_URI="http://sinhala.sourceforge.net/files/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=app-i18n/scim-0.99.8[-gtk3]"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

PATCHES=( "${FILESDIR}"/${P}-gcc43.patch )

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf --disable-static
}

src_install() {
	default

	# plugin module, no point in .la files
	find "${D}" -name '*.la' -delete || die
}
