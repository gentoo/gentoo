# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="CLI frontend for PHP_CodeCoverage"
HOMEPAGE="https://github.com/sebastianbergmann/phpcov"
SRC_URI="https://phar.phpunit.de/${P}.phar"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~x86"
IUSE=""

DEPEND=""
RDEPEND="dev-lang/php:*[phar]
	dev-php/xdebug"

S="${WORKDIR}"

src_unpack() {
	return
}

src_install() {
	exeinto /usr/share/php/${PN}
	newexe "${DISTDIR}"/${P}.phar "${PN}.phar"
	dosym "../share/php/${PN}/${PN}.phar" /usr/bin/${PN}
}
