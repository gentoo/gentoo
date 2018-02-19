# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit php-pear-r2

DESCRIPTION="Abstract base class for HTML classes (PHP5 port of PEAR-HTML_Common package)"
LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86"
IUSE="test"
DEPEND="test? ( dev-php/phpunit )"

src_test() {
	phpunit tests/AllTests.php || die
}
