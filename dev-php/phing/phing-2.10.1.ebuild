# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-php/phing/phing-2.10.1.ebuild,v 1.1 2015/05/04 15:25:01 grknight Exp $

EAPI="5"

DESCRIPTION="PHP project build system based on Apache Ant"
HOMEPAGE="http://www.phing.info/"
SRC_URI="http://www.phing.info/get/phing-${PV}.phar"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+minimal"

DEPEND=""
RDEPEND="!minimal? ( dev-php/phpDocumentor
	dev-php/PHP_CodeCoverage
	>=dev-php/PEAR-HTTP_Request2-2.1.1
	>=dev-php/PEAR-PEAR_PackageFileManager-1.5.2
	>=dev-php/PEAR-VersionControl_SVN-0.3.0_alpha1
	>=dev-php/phpmd-1.1.0
	>=dev-php/phpunit-4.0
	>=dev-php/xdebug-2.0.5
	>=dev-php/simpletest-1.0.1_beta2 )
	dev-lang/php:*[cli,phar,xml,xslt]
	"

S=${WORKDIR}

src_unpack() { :; }

src_install() {
	insinto /usr/share/php/phing
	insopts -m755
	newins "${DISTDIR}/${P}.phar" phing.phar
	dosym /usr/share/php/phing/phing.phar /usr/bin/phing
}

pkg_postinst() {
	if use minimal; then
		elog "You have enabled the minimal USE flag. If you want to use	features"
		elog "from xdebug, phpunit, simpletest and more, disable the"
		elog "USE flag or emerge the packages manually"
	fi
}
