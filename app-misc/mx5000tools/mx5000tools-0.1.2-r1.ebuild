# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="Tools for controlling the LCD on a Logitech MX5000 keyboard"
HOMEPAGE="https://web.archive.org/web/20160409073317/http://home.gna.org/mx5000tools/"
SRC_URI="https://web.archive.org/web/20170225160711/http://download.gna.org/${PN}/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 x86"

RDEPEND="
	dev-libs/glib:2
	media-libs/netpbm:=
"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=( "${FILESDIR}/${P}-find-netpbm-header.patch" )

src_prepare() {
	default

	eautoreconf
}
src_configure() {
	local myeconfargs=(
		--disable-static
	)

	econf "${myeconfargs[@]}"
}

src_install() {
	default

	find "${D}" -name '*.la' -delete || die
}
