# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit php-pear-r2

KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~s390 ~sparc ~x86"

DESCRIPTION="Database abstraction layer for PHP"
LICENSE="PHP-3"
SLOT="0"
IUSE="test"
RESTRICT="!test? ( test )"
DEPEND="test? ( dev-php/PEAR-PEAR )"

DOCS=( doc/TESTERS doc/IDEAS doc/MAINTAINERS doc/STATUS )

src_test() {
	# Requires the "pear" executable from dev-php/PEAR-PEAR, and also
	# a working version of the cli SAPI eselected.
	pear run-tests tests || die

	# The command succeeds regardless of whether or not the test suite
	# passed, but this file is only written when there was a failure.
	[[ -f run-tests.log ]] && die "test suite failed"
}
