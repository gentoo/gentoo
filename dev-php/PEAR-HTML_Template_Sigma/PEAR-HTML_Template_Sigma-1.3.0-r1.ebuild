# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit php-pear-r2

DESCRIPTION="An implementation of Integrated Templates API with template 'compilation' added"
LICENSE="PHP-3.01"
SLOT="0"
KEYWORDS="amd64 ~hppa ~ia64 ppc ppc64 sparc x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="dev-lang/php:*[ctype]"
DEPEND="test? ( ${RDEPEND} dev-php/phpunit )"
PATCHES=( "${FILESDIR}/HTML_Template_Sigma-1.3.0-php7.patch" )

src_test() {
	phpunit tests/AllTests.php || die
}
