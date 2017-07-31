# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PEAR_PV="${PV/_beta/b}"

inherit php-pear-r2

DESCRIPTION="PEAR class for IP v6 calculations"

LICENSE="PHP-3.01"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

DEPEND="test? ( dev-php/phpunit )"

src_test() {
	phpunit "--include-path=${S}" "${S}/tests/AllTests.php" || die
}
