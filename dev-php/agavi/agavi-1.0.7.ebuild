# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="4"

inherit php-pear-lib-r1

DESCRIPTION="PHP5 MVC Application Framework"
HOMEPAGE="http://www.agavi.org/"
SRC_URI="http://www.agavi.org/download/${PV}.tgz"

LICENSE="LGPL-2.1+ icu unicode ZLIB public-domain"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

# currently fails to install with dev-php/PEAR-PEAR_PackageFileManager-1.7.0
DEPEND="
	>=dev-lang/php-5[xml]
	>=dev-php/PEAR-PEAR-1.6.2-r1
	>=dev-php/phing-2.4[-minimal]
	<dev-php/PEAR-PEAR_PackageFileManager-1.7.0
	"

RDEPEND="
	>=dev-php/phing-2.4
	"

src_compile() {
	phing package-pear || die "failed to build pear package"
}

src_install() {
	cd "${WORKDIR}"
	mv "${S}" "${WORKDIR}"/${PV}
	cp -pPR "${WORKDIR}"/${PV}/pear-build/* "${WORKDIR}"/
	cd "${S}"
	php-pear-lib-r1_src_install
}
