# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PEAR_PV="${PV/_beta/b}"

inherit php-pear-r2

DESCRIPTION="PEAR class for IP v6 calculations"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

BDEPEND="test? ( dev-php/phpunit ${RDEPEND})"

src_test() {
	phpunit "--include-path=${S}" "${S}/tests/AllTests.php" || die
}
