# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit php-pear-r2

DESCRIPTION="Dump structured information about a variable"
LICENSE="PHP-3.01"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="examples test"

DEPEND="test? ( dev-php/PEAR-PEAR )"

# The test suite fails due to some deprecation warnings that are output.
# The test cases themselves set error_reporting(E_ALL), so there's no
# easy way to override it.
RESTRICT=test

src_install() {
	use examples && dodoc -r docs/example*.php
	php-pear-r2_src_install
}

src_test() {
	# Requires the "pear" executable from dev-php/PEAR-PEAR.
	pear run-tests tests || die

	# The command succeeds regardless of whether or not the test suite
	# passed, but this file is only written when there was a failure.
	[[ -f run-tests.log ]] && die "test suite failed"
}
