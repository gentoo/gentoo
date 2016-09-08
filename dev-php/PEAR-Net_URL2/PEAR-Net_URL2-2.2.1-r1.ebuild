# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DESCRIPTION="Easy parsing of URLs (PHP5 port of PEAR-Net_URL package)"
LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86"
IUSE=""

MY_PN="${PN/PEAR-/}"
MY_P="${MY_PN}-${PV}"

SRC_URI="http://pear.php.net/get/${MY_P}.tgz"
HOMEPAGE="http://pear.php.net/${MY_PN}"

RDEPEND="dev-lang/php:* dev-php/pear"
DEPEND=""

S="${WORKDIR}/${MY_P}"

DOCS=( docs/6470.php docs/example.php )

src_install() {
	insinto /usr/share/php
	doins -r Net/
	einstalldocs
}

pkg_postinst() {
	peardev install -nrO --force "${WORKDIR}/package.xml" 2> /dev/null
}

pkg_postrm() {
	peardev uninstall -nrO --force pear.php.net/${MY_PN}
}
