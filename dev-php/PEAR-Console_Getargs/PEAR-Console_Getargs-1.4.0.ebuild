# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit php-pear-r2

DESCRIPTION="A command-line arguments parser"

LICENSE="PHP-3"
SLOT="0"
KEYWORDS="~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

DEPEND="test? ( dev-php/phpunit )"

src_test() {
	phpunit tests/ || die
}
