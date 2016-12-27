# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

MY_PN="${PN/PEAR-/}"
MY_P="${MY_PN}-${PV}"

HOMEPAGE="http://pear.php.net/package/${MY_PN}"
SRC_URI="http://pear.php.net/get/${MY_P}.tgz"
DESCRIPTION="Updates an existing package.xml file with a new filelist and changelog"
LICENSE="PHP-3.01"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="minimal"

RDEPEND=">=dev-lang/php-5.3:*
	>=dev-php/PEAR-PEAR-1.10.1
	dev-php/PEAR-PEAR_PackageFileManager_Plugins
	!minimal? ( >=dev-php/PEAR-PHP_CompatInfo-1.4.0 )"

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
