# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="PHP File Scanner"
HOMEPAGE="https://github.com/theseer/DirectoryScanner"
SRC_URI="${HOMEPAGE}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="
	dev-lang/php:*"
DEPEND="
	test? (
		${RDEPEND}
		dev-php/phpunit
		dev-php/xdebug )"

S="${WORKDIR}/DirectoryScanner-${PV}"

src_prepare() {
	default
	if use test; then
		cp "${FILESDIR}"/autoload.php "${S}"/autoload-test.php || die
		sed -i -e "s:__DIR__:__DIR__.'/src':" "${S}"/autoload-test.php || die
	fi
}

src_install() {
	insinto "/usr/share/php/theseer/DirectoryScanner"
	doins -r  src/. "${FILESDIR}"/autoload.php
}

src_test() {
	phpunit --bootstrap "${S}"/autoload-test.php || die "test suite failed"
}
