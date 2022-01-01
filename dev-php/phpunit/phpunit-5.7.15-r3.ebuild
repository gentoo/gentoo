# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="A PHP Unit Testing framework"
HOMEPAGE="https://phpunit.de"
SRC_URI="https://github.com/sebastianbergmann/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~hppa ~ia64 ppc ppc64 ~s390 sparc x86"
IUSE=""

RDEPEND="dev-php/fedora-autoloader
	>=dev-php/File_Iterator-1.4.0
	<dev-php/File_Iterator-2.0
	>=dev-php/Text_Template-1.2.0
	<dev-php/Text_Template-2.0
	>=dev-php/PHP_CodeCoverage-4.0.4
	<dev-php/PHP_CodeCoverage-5.0
	>=dev-php/PHP_Timer-1.0.6
	<dev-php/PHP_Timer-2.0
	<dev-php/myclabs-deepcopy-2.0
	<dev-php/phpspec-prophecy-2.0
	<dev-php/phpunit-mock-objects-4.0
	<dev-php/sebastian-comparator-2.0
	<dev-php/sebastian-diff-2.0
	<dev-php/sebastian-environment-3.0
	<dev-php/sebastian-exporter-3.0
	<dev-php/sebastian-global-state-2.0
	<dev-php/sebastian-object-enumerator-3.0
	<dev-php/sebastian-resource-operations-2.0
	<dev-php/sebastian-version-3.0
	<dev-php/symfony-yaml-4.0
	|| (
		dev-lang/php:7.2[cli(-),json(-),unicode(-),xml(-)]
	)"

src_install() {
	insinto /usr/share/php/PHPUnit
	doins -r src/*
	insinto /usr/share/php/PHPUnit/vendor
	doins "${FILESDIR}/autoload.php"
	exeinto /usr/share/php/PHPUnit
	doexe phpunit
	dosym ../share/php/PHPUnit/phpunit /usr/bin/phpunit
}

pkg_postinst() {
	elog "${PN} can optionally use json, pdo-sqlite and pdo-mysql features."
	elog "If you want those, emerge dev-lang/php with USE=\"json pdo sqlite mysql\"."
}
