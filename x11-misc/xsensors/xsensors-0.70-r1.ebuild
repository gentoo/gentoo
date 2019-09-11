# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools

DESCRIPTION="A hardware health information viewer, interface to lm-sensors"
HOMEPAGE="http://www.linuxhardware.org/xsensors/"
SRC_URI="http://www.linuxhardware.org/xsensors/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""

RDEPEND="x11-libs/gtk+:2
	>=sys-apps/lm-sensors-3"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

PATCHES=( "${FILESDIR}"/${P}-gtk220.patch )

src_prepare() {
	default

	sed -i \
		-e '/-DG.*_DISABLE_DEPRECATED/d' \
		-e 's:-Werror:-Wall:' \
		src/Makefile.am configure.in || die

	mv configure.{in,ac} || die #426262

	eautoreconf
}
