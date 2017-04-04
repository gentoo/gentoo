# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Provides functionality to recursively process PHP variables"
HOMEPAGE="https://github.com/sebastianbergmann/recursion-context"
SRC_URI="${HOMEPAGE}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="
	dev-lang/php:*"
DEPEND="
	${RDEPEND}
	dev-php/theseer-Autoload
	test? (
		dev-php/phpunit
		)"

S="${WORKDIR}/recursion-context-${PV}"

src_prepare() {
	default
	/usr/bin/phpab -o "${S}"/autoload.php -b "${S}"/src "${S}"/composer.json || die
	if use test; then
		cp "${S}"/autoload.php "${S}"/autoload-test.php || die
	fi
}

src_install() {
	insinto "/usr/share/php/SebastianBergmann/RecursionContext"
	doins -r  src/. LICENSE "${S}"/autoload.php
	dodoc README.md
}

src_test() {
	phpunit --bootstrap "${S}"/autoload-test.php || die "test suite failed"
}
