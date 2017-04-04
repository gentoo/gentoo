# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="A set of classes to do different actions with the console"
HOMEPAGE="https://github.com/zetacomponents/ConsoleTools"
SRC_URI="${HOMEPAGE}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="
	dev-lang/php:*
	>=dev-php/zetacomponents-base-1.8"
DEPEND="
	test? (
		${RDEPEND}
		dev-php/phpunit
		dev-php/zetacomponents-unit-test
		)"

PATCHES=(
	"${FILESDIR}/${PN}-pr8.patch"
	"${FILESDIR}/${PN}-upstream.patch"
)

S="${WORKDIR}/ConsoleTools-${PV}"

src_prepare() {
	default
	if use test; then
		cp "${FILESDIR}"/autoload.php "${S}"/autoload-test.php || die
		sed -i -e "s:__DIR__:__DIR__.'/src':" "${S}"/autoload-test.php || die
		echo "
require_once '/usr/share/php/zetacomponents/UnitTest/autoload.php';
" >> "${S}"/autoload-test.php || die
	fi
}

src_install() {
	insinto "/usr/share/php/zetacomponents/ConsoleTools"
	doins -r  src/. "${FILESDIR}"/autoload.php
}

src_test() {
	phpunit --bootstrap "${S}"/autoload-test.php --exclude-group interactive || die "test suite failed"
}
