# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

MY_PN="${PN/PEAR-/}"
KEYWORDS="~alpha amd64 arm hppa ppc ppc64 sparc x86"
DESCRIPTION="OO interface for searching and manipulating LDAP-entries"
HOMEPAGE="https://pear.php.net/package/${MY_PN}"
SRC_URI="http://download.pear.php.net/package/${MY_PN}-${PV}.tgz"
LICENSE="LGPL-2.1"
SLOT="0"
IUSE="examples test"
RESTRICT="!test? ( test )"

RDEPEND="dev-lang/php:*[ldap]
	dev-php/PEAR-PEAR"
DEPEND="test? ( ${RDEPEND} dev-php/phpunit )"

S="${WORKDIR}/${MY_PN}-${PV}"

src_install() {
	use examples && dodoc -r doc/examples
	dodoc doc/*.*
	insinto /usr/share/php
	doins -r Net
}

src_test() {
	phpunit tests/ || die "test suite failed"
}
