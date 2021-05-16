# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

MY_P=${P/_pre/test}
MY_P=${MY_P/-applet/_applet}

DESCRIPTION="Control utility for some special features of some special Logitech USB mice!"
HOMEPAGE="https://wiki.gentoo.org/wiki/No_homepage"
SRC_URI="mirror://gentoo/${MY_P}.tar.gz"
S="${WORKDIR}"/${MY_P}

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"

DEPEND="virtual/libusb:0"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}"/${P}-mx300-mx518.patch
	"${FILESDIR}"/${PN}-0.4_pre1-configure-error-handling.patch
)

src_prepare() {
	default

	mv configure.{in,ac} || die

	# For error handling patch
	eautoreconf
}

src_install() {
	dosbin logitech_applet
	dodoc AUTHORS ChangeLog README doc/article.txt

	docinto examples
	dodoc "${FILESDIR}"/40-logitech_applet.rules
}
