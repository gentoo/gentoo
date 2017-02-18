# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

MY_PN="${PN/doctrine-//}"

DESCRIPTION="Utility to instantiate objects in PHP without invoking their constructors"
HOMEPAGE="https://github.com/doctrine/${MY_PN}"
SRC_URI="${HOMEPAGE}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="test"

S="${WORKDIR}/${MY_PN}-${PV}"

RDEPEND="
	dev-lang/php:*
	dev-php/fedora-autoloader"
DEPEND="
	test? (
		${RDEPEND}
		dev-lang/php:*[pdo,phar]
		>=dev-php/phpunit-4.0
		>=dev-php/PHP_CodeSniffer-2.0
		)"

src_prepare() {
	default
	if use test; then
		cp "${FILESDIR}"/autoload.php "${S}"/autoload-test.php || die
	fi
}

src_install() {
	insinto /usr/share/php/
	doins -r src/*
	insinto /usr/share/php/Doctrine/Instantiator
	doins "${FILESDIR}/autoload.php"
	dodoc README.md
}

src_test() {
	phpunit --bootstrap "${S}"/autoload-test.php || die "test suite failed"
}
