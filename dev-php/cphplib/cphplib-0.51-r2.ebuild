# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Cute PHP Library (cphplib)"
HOMEPAGE="http://cphplib.sourceforge.net/"
SRC_URI="https://download.sourceforge.net/cphplib/${P}.tar.bz2"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="dev-php/PEAR-DB"
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}/${PN}-0.51-constructor.patch" )

src_install() {
	insinto "/usr/share/php/cphplib"
	doins -r i18n cphplib_formular.inc  cphplib.inc

	docinto html
	dodoc -r doc/.
	einstalldocs
}
