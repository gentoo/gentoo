# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="A PHP Unit Testing framework"
HOMEPAGE="https://phpunit.de"
SRC_URI="https://github.com/sebastianbergmann/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~s390 ~sparc ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-php/fedora-autoloader
	>=dev-php/doctrine-instantiator-1.2.0
	>=dev-php/myclabs-deepcopy-1.9.1
	>=dev-php/phar-io-manifest-1.0.3
	>=dev-php/phar-io-version-2.0.1-r1
	>=dev-php/phpspec-prophecy-1.8.1
	>=dev-php/PHP_CodeCoverage-7.0.7
	>=dev-php/File_Iterator-2.0.2
	>=dev-php/Text_Template-1.2.1
	>=dev-php/PHP_Timer-2.1.2
	>=dev-php/sebastian-comparator-3.0.2
	>=dev-php/sebastian-diff-3.0.2
	>=dev-php/sebastian-environment-4.2.3-r1
	>=dev-php/sebastian-exporter-3.1.1
	>=dev-php/sebastian-global-state-3.0.0
	>=dev-php/sebastian-object-enumerator-3.0.3
	>=dev-php/sebastian-resource-operations-2.0.1
	>=dev-php/sebastian-type-1.1.3
	>=dev-php/sebastian-version-2.0.1
	>=dev-lang/php-7.2:*[cli(-),json(-),unicode(-),xml(-),xmlwriter(-)]
	"
DEPEND="
	test? (
		${RDEPEND}
		>=dev-lang/php-7.2:*[pdo(-)]
		dev-php/phpspec-prophecy
	)
	"

src_prepare() {
	default
	if use test; then
		mkdir "${S}"/vendor
		cp "${FILESDIR}/${PV}"-autoload-test.php "${S}"/vendor/autoload.php || die
	fi
}

src_test() {
	php ./phpunit || die "test suite failed"
}

src_install() {
	insinto /usr/share/php/PHPUnit
	doins -r src/*
	insinto /usr/share/php/PHPUnit/vendor
	newins "${FILESDIR}/${PV}"-autoload.php autoload.php
	exeinto /usr/share/php/PHPUnit
	doexe phpunit
	dosym ../share/php/PHPUnit/phpunit /usr/bin/phpunit
	insinto /usr/share/php
	doins phpunit.xsd
	dodoc README.md
}

pkg_postinst() {
	if [[ -n ${REPLACING_VERSIONS} ]]; then
		elog "${PN} can optionally use json, pdo-sqlite and pdo-mysql features."
		elog "If you want those, emerge dev-lang/php with USE=\"json pdo sqlite mysql\"."
	fi
}
