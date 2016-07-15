# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DESCRIPTION="Detect violations of PHP code standards"
HOMEPAGE="https://github.com/squizlabs/PHP_CodeSniffer"

inherit php-pear-r1

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

DEPEND="test? ( >=dev-php/phpunit-4 )"
RDEPEND="dev-lang/php:*[cli,tokenizer,xmlwriter]"

DOCS=( CONTRIBUTING.md README.md )

src_install() {
	php-pear-r1_src_install
	einstalldocs
}

src_test() {
	phpunit "${S}/tests/AllTests.php" || die "test suite failed"
}
