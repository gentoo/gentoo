# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

MY_PN="${PN/PEAR-/}"
MY_P="${MY_PN}-${PV}"

HOMEPAGE="http://pear.php.net/package/${MY_PN}"
SRC_URI="http://pear.php.net/get/${MY_P}.tgz"
DESCRIPTION="Various methods to check files to update an existing package.xml file"
LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=dev-php/PEAR-PEAR-1.10.1
	>=dev-php/PEAR-XML_Serializer-0.19.0
	>=dev-lang/php-5.3:*[xml,simplexml]"

S="${WORKDIR}/${MY_P}"

src_install() {
	insinto /usr/share/php
	doins -r PEAR
}

pkg_postinst() {
	# Register the package from the package.xml file
	# Operation is not critical so die is not required
	if [[ -f "${WORKDIR}/package.xml" ]] ; then
		"${EROOT}usr/bin/peardev" install -nrO --force "${WORKDIR}/package.xml" 2> /dev/null
	fi
}

pkg_postrm() {
	# Uninstall known dependency
	"${EROOT}usr/bin/peardev" uninstall -nrO "pear.php.net/${MY_PN}"
}
