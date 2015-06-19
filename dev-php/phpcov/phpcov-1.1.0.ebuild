# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-php/phpcov/phpcov-1.1.0.ebuild,v 1.1 2014/01/06 20:11:43 mabi Exp $

EAPI=5

DESCRIPTION="CLI frontend for PHP_CodeCoverage"
HOMEPAGE="https://github.com/sebastianbergmann/phpcov"
SRC_URI="https://phar.phpunit.de/${P}.phar"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~x86"
IUSE=""

DEPEND=""
RDEPEND="dev-lang/php[phar]
	dev-php/xdebug"

S="${WORKDIR}"

src_unpack() {
	return
}

src_install() {
	insinto /usr/share/php/${PN}
	insopts -m755
	newins "${DISTDIR}"/${P}.phar "${PN}.phar"
	dosym /usr/share/php/${PN}/${PN}.phar /usr/bin/${PN}
}
