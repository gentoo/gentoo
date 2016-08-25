# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DESCRIPTION="Detect violations of PHP code standards"
HOMEPAGE="https://github.com/squizlabs/PHP_CodeSniffer"

# The test suite isn't part of the Github tarball at the moment. Keep an
# eye on https://github.com/squizlabs/PHP_CodeSniffer/issues/548
SRC_URI="http://download.pear.php.net/package/${P}.tgz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

DEPEND="test? ( >=dev-php/phpunit-4 )"
RDEPEND="dev-lang/php:*[cli,tokenizer,xmlwriter]"

DOCS=( CONTRIBUTING.md README.md )
src_install() {
	# The PEAR eclass would install everything into the wrong location.
	insinto "/usr/share/${PN}"
	doins -r CodeSniffer CodeSniffer.php

	# These load code via relative paths, so they have to be symlinked
	# and not dobin'd.
	exeinto "/usr/share/${PN}/scripts"
	for script in phpcbf phpcs; do
		doexe "scripts/${script}"
		dosym "/usr/share/${PN}/scripts/${script}" "/usr/bin/${script}"
	done

	einstalldocs
}

src_test() {
	# The test suite will fail if date.timezone isn't set in php.ini.
	phpunit -d date.timezone=UTC tests/AllTests.php \
		|| die "test suite failed"
}
