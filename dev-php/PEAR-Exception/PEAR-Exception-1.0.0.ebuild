# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

MY_PN="${PN/-/_}"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="The PEAR Exception base class"
HOMEPAGE="http://pear.php.net/package/${MY_PN}"
SRC_URI="http://download.pear.php.net/package/${MY_P}.tgz"
LICENSE="BSD-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ppc ppc64 ~s390 ~sh sparc x86"
IUSE="test"
RDEPEND="dev-lang/php:*
	!<=dev-php/PEAR-PEAR-1.10.3-r1"
DEPEND="test? ( ${RDEPEND} dev-php/phpunit )"
S="${WORKDIR}/${MY_P}"

src_install() {
	insinto /usr/share/php
	doins -r PEAR
}

src_test() {
	phpunit tests || die "test suite failed"
}
