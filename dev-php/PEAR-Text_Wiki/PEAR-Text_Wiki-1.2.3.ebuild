# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit php-pear-r2

DESCRIPTION="Abstracts parsing and rendering rules for Wiki markup in structured plain text"
LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

DEPEND="test? ( dev-php/phpunit dev-php/PEAR-PEAR )"

src_test() {
	peardev run-tests tests || die
	phpunit tests/*.php || die
}
