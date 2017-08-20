# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="JSON Lint for PHP"
HOMEPAGE="https://github.com/Seldaek/jsonlint"
SRC_URI="${HOMEPAGE}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="test"

RDEPEND="
	dev-lang/php:*
	dev-php/fedora-autoloader"
DEPEND="
	test? (
		${RDEPEND}
		dev-php/phpunit )"

src_prepare() {
	default
	if use test; then
		cp "${FILESDIR}"/autoload.php "${S}"/autoload-test.php || die
		sed -i -e "s:__DIR__:'${S}/src/Seld/JsonLint':" "${S}"/autoload-test.php || die
	fi
}

src_install() {
	insinto "/usr/share/php/Seld/JsonLint"
	doins -r src/Seld/JsonLint/. "${FILESDIR}"/autoload.php
	dodoc README.mdown
}

src_test() {
	phpunit --bootstrap "${S}"/autoload-test.php || die "test suite failed"
}
