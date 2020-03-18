# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

MY_PN="${PN#PEAR-}"
DESCRIPTION="PHP and JavaScript AJAX library"
LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
HOMEPAGE="https://pear.php.net/package/HTML_AJAX/"
SRC_URI="http://download.pear.php.net/package/${MY_PN}-${PV}.tgz"
S="${WORKDIR}/${MY_PN}-${PV}"

src_install() {
	insinto /usr/share/php
	doins -r HTML
	insinto "/usr/share/php/data/${MY_PN}"
	doins -r js
}
