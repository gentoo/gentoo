# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit php-pear-r2

DESCRIPTION="Color conversion and mixing for PHP5"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"
DEPEND="test? ( >=dev-php/phpunit-5 )"

src_prepare() {
	# Modernize tests
	sed -i -e "/require_once 'PHPUnit\/Framework.php';/d" \
		-e "s/assertType('\(Image_[a-zA-Z2_]*\)',/assertInstanceOf(\1::class,/" \
		-e "s/assertType('array',/assertInternalType('array',/" \
		-e "s/assertType('string',/assertInternalType('string',/" \
		tests/*.php tests/Model/*.php || die
	default
}

src_test() {
	phpunit tests/AllTests.php || die
}
