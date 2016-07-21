# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

MY_PN="${PN/PEAR-/}"
KEYWORDS="~amd64 ~hppa ~x86"
DESCRIPTION="OO interface for searching and manipulating LDAP-entries"
HOMEPAGE="https://pear.php.net/package/${MY_PN}"
SRC_URI="http://download.pear.php.net/package/${MY_PN}-${PV}.tgz"
LICENSE="LGPL-2.1"
SLOT="0"
IUSE="examples test"

RDEPEND="dev-lang/php:*[ldap]"
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
