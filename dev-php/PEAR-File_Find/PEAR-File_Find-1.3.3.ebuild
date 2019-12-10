# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

MY_PN="${PN/PEAR-/}"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="A class that facillitates the search of filesystems"
HOMEPAGE="https://pear.php.net/package/${MY_PN}"
SRC_URI="http://download.pear.php.net/package/${MY_P}.tgz"
LICENSE="PHP-3.01"
SLOT="0"
KEYWORDS="~alpha amd64 hppa ia64 ppc ppc64 sparc x86"
IUSE="test"
RESTRICT="!test? ( test )"

# Really only needs PEAR-Exception at runtime.
RDEPEND="dev-lang/php:*
	dev-php/PEAR-PEAR"
DEPEND="test? ( dev-php/PEAR-PEAR )"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	eapply_user

	# Without this sed, the test suite will try (and fail) to mess
	# around in /tmp.
	sed -i "s~'/tmp'~'${T}'~" tests/setup.php \
		|| die 'failed to fix temporary directory in tests/setup.php'
}

src_install() {
	insinto /usr/share/php
	doins -r File
}

src_test() {
	# Requires the "pear" executable from dev-php/PEAR-PEAR.
	pear run-tests tests || die

	# The command succeeds regardless of whether or not the test suite
	# passed, but this file is only written when there was a failure.
	[[ -f run-tests.log ]] && die "test suite failed"
}
