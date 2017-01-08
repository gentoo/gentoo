# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

MY_PN="${PN/PEAR-/}"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Dump structured information about a variable"
HOMEPAGE="http://pear.php.net/package/${MY_PN}"
SRC_URI="http://download.pear.php.net/package/${MY_P}.tgz"
LICENSE="PHP-3.01"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="examples test"

RDEPEND="dev-lang/php:*
	dev-php/PEAR-PEAR"
DEPEND="test? ( ${RDEPEND} )"

S="${WORKDIR}/${MY_P}"

# The test suite fails due to some deprecation warnings that are output.
# The test cases themselves set error_reporting(E_ALL), so there's no
# easy way to override it.
RESTRICT=test

src_install() {
	use examples && dodoc -r docs/example*.php

	insinto /usr/share/php
	doins "${MY_PN}.php"
	doins -r "${MY_PN}"
}

src_test() {
	# Requires the "pear" executable from dev-php/PEAR-PEAR.
	pear run-tests tests || die

	# The command succeeds regardless of whether or not the test suite
	# passed, but this file is only written when there was a failure.
	[[ -f run-tests.log ]] && die "test suite failed"
}
