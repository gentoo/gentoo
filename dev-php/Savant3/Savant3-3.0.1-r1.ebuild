# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

KEYWORDS="~amd64 ~x86"

DESCRIPTION="The simple PHP template alternative to Smarty"
HOMEPAGE="https://github.com/saltybeagle/Savant3"

# This is the last commit before the Composer integration broke
# everything.
COMMIT=f3b4b70422bc743168d8e01443abc385d8acbef9
SRC_URI="https://github.com/saltybeagle/Savant3/archive/${COMMIT}.tar.gz"
LICENSE="LGPL-2.1"
SLOT="0"
IUSE="minimal test"

DEPEND="test? ( dev-php/phpunit )"
RDEPEND="dev-lang/php:*
	!minimal? ( >=dev-php/Savant3-Plugin-Form-0.2.1 )"

S="${WORKDIR}/${PN}-${COMMIT}"

src_install() {
	dodoc README.md
	insinto /usr/share/php/
	doins "${PN}.php"
	doins -r "${PN}"
}

src_test() {
	cd tests && phpunit . || die "test suite failed"
}

pkg_postinst() {
	elog "${PN} has been installed in /usr/share/php/."
	elog
	elog "To use it in your scripts, include the ${PN}.php file."
	elog "For example,"
	elog
	elog "  require('${PN}.php');"
	elog
}
