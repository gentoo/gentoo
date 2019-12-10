# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

MY_PN="${PN/PEAR-/}"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Provides methods for spelling numerals in words"
HOMEPAGE="https://pear.php.net/package/${MY_PN}"
SRC_URI="http://download.pear.php.net/package/${MY_P}.tgz"
LICENSE="PHP-3.01"
SLOT="0"
KEYWORDS="~alpha amd64 hppa ia64 ppc ppc64 sparc x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="dev-lang/php:*
	dev-php/PEAR-Math_BigInteger"
DEPEND="test? ( ${RDEPEND} dev-php/phpunit )"

S="${WORKDIR}/${MY_P}"

src_install() {
	insinto /usr/share/php/
	doins -r Numbers

	dodoc ChangeLog README
}

src_test() {
	phpunit tests || die 'test suite failed'
}
