# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="TCPDF is a FLOSS PHP class for generating PDF documents"
HOMEPAGE="http://www.tcpdf.org/"
SRC_URI="https://github.com/tecnickcom/TCPDF/archive/${PV}.tar.gz
	-> ${P}.tar.gz"
# Main source is LGPL-3+, some included fonts have other licenses
LICENSE="LGPL-3+ GPL-3 BitstreamVera GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="examples"

RDEPEND="dev-lang/php"

S="${WORKDIR}/${P^^}"

src_install() {
	insinto /etc
	doins config/tcpdf_config.php
	# Create a symlink for the config file, because the library will only
	# look for it in its own source tree (not in /etc where we've put it).
	dosym ../../../../../etc/tcpdf_config.php "/usr/share/php/${PN}/config/tcpdf_config.php"

	exeinto "/usr/share/php/${PN}/tools"
	doexe tools/tcpdf_addfont.php

	insinto "/usr/share/php/${PN}"
	doins tcpdf*.php
	doins -r include fonts
	dodoc CHANGELOG.TXT README.md

	use examples && dodoc -r examples
}
