# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="A PHP Unit Testing framework"
HOMEPAGE="https://phpunit.de"
SRC_URI="https://github.com/sebastianbergmann/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~hppa ~ia64 ppc ppc64 ~s390 sparc x86"

BDEPEND="dev-php/theseer-Autoload"

RDEPEND="dev-php/fedora-autoloader
	>=dev-php/File_Iterator-2.0.2
	>=dev-php/Text_Template-1.2.1
	>=dev-php/PHP_CodeCoverage-7.0.12
	>=dev-php/PHP_Timer-2.1.2
	>=dev-php/doctrine-instantiator-1.3.1
	>=dev-php/myclabs-deepcopy-1.10.0
	>=dev-php/phar-io-manifest-1.0.3
	>=dev-php/phar-io-version-2.0.1
	>=dev-php/phpspec-prophecy-1.10.3
	>=dev-php/sebastian-comparator-3.0.2
	>=dev-php/sebastian-diff-3.0.2
	>=dev-php/sebastian-environment-4.2.3
	>=dev-php/sebastian-exporter-3.1.2
	>=dev-php/sebastian-global-state-3.0.0
	>=dev-php/sebastian-object-enumerator-3.0.3
	>=dev-php/sebastian-resource-operations-2.0.1
	>=dev-php/sebastian-type-1.1.3
	>=dev-php/sebastian-version-2.0.1
	|| (
		dev-lang/php:7.4[cli(-),json(-),unicode(-),xml(-),xmlwriter(-)]
		dev-lang/php:7.3[cli(-),json(-),unicode(-),xml(-),xmlwriter(-)]
		dev-lang/php:7.2[cli(-),json(-),unicode(-),xml(-),xmlwriter(-)]
	)
	!dev-php/phpunit-mock-objects
"

src_prepare() {
	default

	mkdir src/vendor || die

	phpab \
		--output   src/vendor/autoload.php \
		--template fedora2 \
		--basedir  src/vendor \
		src || die

	cat >> src/vendor/autoload.php <<EOF || die "failed to extend autoload.php"

// Dependencies
\Fedora\Autoloader\Dependencies::required([
	__DIR__ . '/../../File/Iterator/autoload.php',
	__DIR__ . '/../../Text/Template/autoload.php',
	__DIR__ . '/../../PHP/CodeCoverage/autoload.php',
	__DIR__ . '/../../PHP/Timer/autoload.php',
	__DIR__ . '/../../phpspec/Prophecy/autoload.php',
	__DIR__ . '/../../SebastianBergmann/Diff/autoload.php', // Before comparator which may load v2
	__DIR__ . '/../../SebastianBergmann/Comparator/autoload.php',
	__DIR__ . '/../../SebastianBergmann/Environment/autoload.php',
	__DIR__ . '/../../SebastianBergmann/Exporter/autoload.php',
	__DIR__ . '/../../SebastianBergmann/GlobalState/autoload.php',
	__DIR__ . '/../../SebastianBergmann/ObjectEnumerator/autoload.php',
	__DIR__ . '/../../SebastianBergmann/ResourceOperations/autoload.php',
	__DIR__ . '/../../SebastianBergmann/Type/autoload.php',
	__DIR__ . '/../../SebastianBergmann/Version/autoload.php',
	__DIR__ . '/../../Doctrine/Instantiator/autoload.php',
	__DIR__ . '/../../myclabs/DeepCopy/autoload.php',
	__DIR__ . '/../../PharIo/Manifest/autoload.php',
	__DIR__ . '/../../PharIo/Version/autoload.php',
]);
EOF
}

src_install() {
	insinto /usr/share/php/PHPUnit
	doins -r src/*

	# referenced by PHPUnit/Util/Configuration.php
	insinto /usr/share/php/
	doins phpunit.xsd

	exeinto /usr/share/php/PHPUnit
	doexe phpunit
	dosym ../share/php/PHPUnit/phpunit /usr/bin/phpunit
}

pkg_postinst() {
	elog "${PN} can optionally use json, pdo-sqlite and pdo-mysql features."
	elog "If you want those, emerge dev-lang/php with USE=\"json pdo sqlite mysql\"."
}
