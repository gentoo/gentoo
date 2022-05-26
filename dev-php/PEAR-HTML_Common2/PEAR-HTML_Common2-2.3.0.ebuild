# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit php-pear-r2

DESCRIPTION="Abstract base class for HTML classes (PHP5 port of PEAR-HTML_Common package)"
LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~s390 ~sparc ~x86"
#IUSE="test"
#RESTRICT="!test? ( test )"
# Tests fail with current phpunit
RESTRICT="test"
#BDEPEND="test? ( dev-php/phpunit )"

src_test() {
	phpunit tests/AllTests.php || die
}
