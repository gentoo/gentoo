# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"

inherit php-pear-r2

DESCRIPTION="Command-line arguments parser"

LICENSE="PHP-3"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86"

IUSE="test"
RESTRICT="!test? ( test )"
DEPEND="test? ( dev-php/PEAR-PEAR )"

src_test() {
	pear run-tests tests || die "Tests failed"
}
