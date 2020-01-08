# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

MY_PN="${PN/PEAR-/}"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="PHP command-line execution interface"
HOMEPAGE="https://pear.php.net/package/${MY_PN}"
SRC_URI="http://download.pear.php.net/package/${MY_P}.tgz"
LICENSE="PHP-3.01"
SLOT="0"
KEYWORDS="~alpha amd64 hppa ia64 ppc ppc64 sparc x86"
IUSE="examples"

RDEPEND="dev-lang/php:*
	dev-php/PEAR-PEAR"

S="${WORKDIR}/${MY_P}"

src_install() {
	use examples && dodoc -r docs/test.php

	insinto /usr/share/php
	doins -r System
}
