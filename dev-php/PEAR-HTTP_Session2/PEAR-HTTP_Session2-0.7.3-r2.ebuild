# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit php-pear-r2

DESCRIPTION="Wraps PHP's session functions providing extras like db storage for session data"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="minimal test"
RESTRICT="!test? ( test )"

RDEPEND="!minimal? ( >=dev-php/PEAR-MDB2-2.4.1
			>=dev-php/PEAR-DB-1.7.11 )"
DEPEND="test? ( dev-php/PEAR-PEAR )"

src_test() {
	pear run-tests tests || die "Tests failed"
}
