# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="A lightweight php namespace aware autoload generator and phar archive builder"
HOMEPAGE="https://github.com/theseer/Autoload"
SRC_URI="${HOMEPAGE}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="
	dev-lang/php:*
	dev-php/fedora-autoloader
	>=dev-php/theseer-DirectoryScanner-1.3.1
	>=dev-php/zetacomponents-console-tools-1.7"
DEPEND="
	test? (
		${RDEPEND}
		dev-php/phpunit
		>=dev-php/PHP_CodeSniffer-1.5
		dev-php/xdebug
		)"

S="${WORKDIR}/Autoload-${PV}"

src_prepare() {
	default
	sed -i -e "s:%development%:${PV}:" "${S}"/composer/bin/phpab || die
	sed -i -e "s:require __DIR__ . '/../../src/autoload.php':require '/usr/share/php/theseer/Autoload/autoload.php':" "${S}"/composer/bin/phpab || die
	if use test; then
		cp "${FILESDIR}"/autoload.php "${S}"/autoload-test.php || die
		sed -i -e "s:__DIR__:__DIR__.'/src':" "${S}"/autoload-test.php || die
	fi
}

src_install() {
	insinto "/usr/share/php/theseer/Autoload"
	doins -r  src/. LICENSE "${FILESDIR}"/autoload.php
	dobin composer/bin/phpab
	dodoc README.md
}

src_test() {
	phpunit --bootstrap "${S}"/autoload-test.php || die "test suite failed"
}
