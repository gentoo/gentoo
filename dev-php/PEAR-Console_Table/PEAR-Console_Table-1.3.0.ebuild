# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

MY_PN="${PN/PEAR-/}"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Class that makes it easy to build console style tables"
HOMEPAGE="http://pear.php.net/package/${MY_PN}"
SRC_URI="http://pear.php.net/get/${MY_P}.tgz"
LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE=""

RDEPEND="dev-php/PEAR-PEAR dev-lang/php:*"

S="${WORKDIR}/${MY_P}"

src_install() {
	insinto /usr/share/php/Console
	doins Table.php
}

pkg_postinst() {
	# Register the package from the package.xml file
	"${EROOT}usr/bin/peardev" install -nrO --force "${WORKDIR}/package.xml" 2> /dev/null || die
}

pkg_postrm() {
	# Uninstall known dependency
	"${EROOT}usr/bin/peardev" uninstall -nrO "pear.php.net/${MY_PN}"
}
