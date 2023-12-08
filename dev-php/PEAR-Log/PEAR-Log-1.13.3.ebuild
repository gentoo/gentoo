# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PN="${PN/PEAR-/}"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="The Log framework provides an abstracted logging system"
HOMEPAGE="https://pear.php.net/package/Log"
SRC_URI="http://download.pear.php.net/package/${MY_P}.tgz"
LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 arm ~hppa ~ia64 ppc ppc64 ~s390 sparc x86"
IUSE="examples test"
RESTRICT="!test? ( test )"

# The DB, Mail, and MDB2 dependencies are technically optional, but
# automagic. To avoid surprises, we require them unconditionally.
CDEPEND="dev-lang/php:*
	dev-php/PEAR-PEAR
	dev-php/PEAR-DB
	dev-php/PEAR-Mail
	dev-php/PEAR-MDB2"

BDEPEND="test? ( ${CDEPEND} )"

RDEPEND="${CDEPEND}"

S="${WORKDIR}/${MY_P}"

src_test() {
	# Requires the "pear" executable from dev-php/PEAR-PEAR.
	pear run-tests tests || die

	# The command succeeds regardless of whether or not the test suite
	# passed, but this file is only written when there was a failure.
	[[ -f run-tests.log ]] && die "test suite failed"
}

src_install() {
	dodoc docs/guide.txt misc/log.sql
	use examples && dodoc -r examples

	# I don't like installing "Log.php" right at the top-level, but any
	# packages depending on us will expect to find it there and not as
	# e.g. Log/Log.php.
	insinto "/usr/share/php/"
	doins Log.php
	doins -r Log
}
