# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

MY_PN="${PN/PEAR-/}"
MY_P="${MY_PN}-${PV}"

HOMEPAGE="http://pear.php.net/package/${MY_PN}"
SRC_URI="http://pear.php.net/get/${MY_P}.tgz"
DESCRIPTION="Net_SmartIRC is a PHP class for communication with IRC networks"
LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE=""

RDEPEND="dev-php/PEAR-PEAR >=dev-lang/php-5.3:*"

S="${WORKDIR}/${MY_P}"

src_install() {
	local DOCS=( README.md CREDITS FEATURES )
	insinto /usr/share/php
	doins -r Net
	einstalldocs
}

pkg_postinst() {
	# Register the package from the package.xml file
	"${EROOT}usr/bin/peardev" install -nrO --force "${WORKDIR}/package.xml" 2> /dev/null || die
}

pkg_postrm() {
	# Uninstall known dependency
	"${EROOT}usr/bin/peardev" uninstall -nrO "pear.php.net/${MY_PN}"
}
