# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

USE_PHP="php7-2 php7-3 php7-4"
MY_PN="php-code-coverage"

DESCRIPTION="Collection, processing, and rendering for PHP code coverage"
HOMEPAGE="http://phpunit.de"
SRC_URI="https://github.com/sebastianbergmann/${MY_PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86"
IUSE="test"

S="${WORKDIR}/${MY_PN}-${PV}"

RDEPEND="dev-php/fedora-autoloader
	>=dev-php/File_Iterator-2.0.2
	<dev-php/File_Iterator-3.0
	>=dev-php/Text_Template-1.2.1
	<dev-php/Text_Template-2.0
	>=dev-php/PHP_TokenStream-3.1.1
	<dev-php/PHP_TokenStream-4.0
	>=dev-php/sebastian-environment-4.2.2
	<dev-php/sebastian-environment-5.0
	>=dev-php/sebastian-version-2.0.1
	<dev-php/sebastian-version-3.0
	dev-php/sebastian-code-unit-reverse-lookup
	<dev-php/sebastian-code-unit-reverse-lookup-2.0
	>=dev-php/theseer-tokenizer-1.1.3
	<dev-php/theseer-tokenizer-2.0
	|| (
		dev-lang/php:7.2[xml(-),xmlwriter(-)]
		dev-lang/php:7.3[xml(-),xmlwriter(-)]
		dev-lang/php:7.4[xml(-),xmlwriter(-)]
	)"
BDEPEND="test? ( ${RDEPEND} dev-php/phpunit )"
# Test currently do not work.  Cannot find TestCase.php
RESTRICT="test"

src_install() {
	insinto /usr/share/php/PHP/CodeCoverage
	doins -r src/*
	newins "${FILESDIR}/autoload-7.0.10.php" autoload.php
}

src_test() {
	mkdir vendor || die
	cp "${FILESDIR}/autoload-7.0.10.php" vendor/autoload.php || die
	sed -i 's~__DIR__~__DIR__."/../src"~' vendor/autoload.php || die
	ln -s ../tests/TestCase.php src/TestCase.php || die
	for target in ${USE_PHP//-/.} ; do
		if [ -x /usr/bin/$target ] ; then
			${target} /usr/bin/phpunit -c phpunit.xml || die
		fi
	done
	rm src/TestCase.php || die
}

pkg_postinst() {
	ewarn "This library now loads via /usr/share/php/PHP/CodeCoverage/autoload.php"
	ewarn "Please update any scripts to require the autoloader"
}
