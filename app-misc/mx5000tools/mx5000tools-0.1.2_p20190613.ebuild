# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

MX5000_TOOLS_COMMIT="c575ea33f92495b4b0ccdb1ce09099f9c011e43f"
DESCRIPTION="Tools for controlling the LCD on a Logitech MX5000 keyboard"
HOMEPAGE="https://web.archive.org/web/20160409073317/http://home.gna.org/mx5000tools/"
SRC_URI="https://github.com/jwrdegoede/mx5000tools/archive/${MX5000_TOOLS_COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}"/${PN}-${MX5000_TOOLS_COMMIT}

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"

RDEPEND="
	dev-libs/glib:2
	media-libs/netpbm:=
"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

src_prepare() {
	default

	eautoreconf
}

src_install() {
	default

	find "${ED}" -name '*.la' -delete || die
}
