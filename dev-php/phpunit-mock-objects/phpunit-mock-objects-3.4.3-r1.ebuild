# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Mock Object library for PHPUnit"
HOMEPAGE="https://github.com/sebastianbergmann/phpunit-mock-objects"
SRC_URI="${HOMEPAGE}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
# 20170204- test are crashing in php5
RESTRICT="test"

RDEPEND="
	dev-lang/php:*
	dev-php/fedora-autoloader
	>=dev-php/doctrine-instantiator-1.0.2
	>=dev-php/phpunit-php-text-template-1.2
	>=dev-php/sebastianbergmann-exporter-1.2"
DEPEND="
	test? (
		${RDEPEND}
		dev-php/phpunit )"

src_prepare() {
	default
	if use test; then
		cp "${FILESDIR}"/autoload.php "${S}"/autoload-test.php || die
	fi
}

src_install() {
	insinto "/usr/share/php/phpunit-mock-object"
	doins -r  src/Framework/MockObject/. LICENSE "${FILESDIR}"/autoload.php
	dodoc README.md
}

src_test() {
	phpunit --bootstrap "${S}"/autoload-test.php || die "test suite failed"
}
