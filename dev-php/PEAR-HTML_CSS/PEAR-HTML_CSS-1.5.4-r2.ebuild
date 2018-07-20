# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit php-pear-r2

DESCRIPTION="Provides a simple interface for generating a stylesheet declaration"
LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="minimal test"
RDEPEND=">=dev-php/PEAR-HTML_Common-1.2.4
	!minimal? ( >=dev-php/PEAR-Services_W3C_CSSValidator-0.1.0 )"
DEPEND="test? ( ${RDEPEND} >=dev-php/phpunit-3.7 )"
PATCHES=( "${FILESDIR}/HTML_CSS-1.5.4-fix-tests.patch" )

src_prepare() {
	mkdir HTML || die
	mv CSS CSS.php HTML || die
	default
}

src_test() {
	ln -s ../HTML tests/HTML || die
	phpunit tests/AllTests.php || die
}
