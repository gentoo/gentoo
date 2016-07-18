# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

# Can go if we ever drop the "PEAR-" prefix.
MY_PN="${PN#PEAR-}"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Detect violations of PHP code standards"
HOMEPAGE="https://github.com/squizlabs/PHP_CodeSniffer"

SRC_URI="http://download.pear.php.net/package/${MY_P}.tgz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

DEPEND="test? ( >=dev-php/phpunit-4 )"
RDEPEND="dev-lang/php:*[cli,tokenizer,xmlwriter]"

# Can go if we ever drop the "PEAR-" prefix.
S="${WORKDIR}/${MY_P}"

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
