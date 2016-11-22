# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="6"

DESCRIPTION="Unit-test framework for Bourne-based shell scripts"
HOMEPAGE="https://github.com/kward/shunit2"
SRC_URI="https://shunit2.googlecode.com/files/${P}.tgz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 ~ppc ~x86"
IUSE=""

src_install() {
	dobin src/shunit2

	# For backwards compat to <=2.1.5
	dosym /usr/bin/shunit2 /usr/share/shunit2/shunit2

	dodoc -r examples
	dodoc doc/*.txt

	docinto html
	dodoc doc/*.{html,css}
}
