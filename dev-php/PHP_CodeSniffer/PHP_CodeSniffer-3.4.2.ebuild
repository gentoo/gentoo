# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Detect violations of PHP code standards"
HOMEPAGE="https://github.com/squizlabs/PHP_CodeSniffer"

# The test suite isn't part of the Github tarball at the moment. Keep an
# eye on https://github.com/squizlabs/PHP_CodeSniffer/issues/548
SRC_URI="http://download.pear.php.net/package/${P}.tgz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="dev-lang/php:*[cli,tokenizer,xmlwriter]"
DEPEND="test? ( >=dev-php/phpunit-4 ${RDEPEND} )"

DOCS=( CONTRIBUTING.md README.md )

src_prepare() {
	sed -i "s~@data_dir@~${EPREFIX}/usr/share/php/data~" src/Config.php || die
	eapply_user
}

src_install() {
	local MY_PN="PHP/CodeSniffer" script
	# The PEAR eclass would install everything into the wrong location.
	insinto "/usr/share/php/${MY_PN}"
	doins -r src autoload.php

	insinto "/usr/share/php/data/${MY_PN}"
	doins CodeSniffer.conf.dist
	# These load code via relative paths, so they have to be symlinked
	# and not dobin'd.
	exeinto "/usr/share/php/${MY_PN}/bin"
	for script in phpcbf phpcs; do
		doexe "bin/${script}"
		dosym "../share/php/${MY_PN}/bin/${script}" "/usr/bin/${script}"
	done

	einstalldocs
}

src_test() {
	# The test suite will fail if date.timezone isn't set in php.ini.
	phpunit -d date.timezone=UTC tests/AllTests.php \
		|| die "test suite failed"
}
