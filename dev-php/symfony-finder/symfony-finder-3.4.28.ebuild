# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Symfony Finder Component"
HOMEPAGE="https://github.com/symfony/finder"
SRC_URI="https://github.com/symfony/finder/archive/v${PV}.tar.gz -> symfony-finder-${PV}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="dev-lang/php:*
	dev-php/fedora-autoloader"
DEPEND="test? ( ${RDEPEND} >=dev-php/phpunit-5.7.15 )"

S="${WORKDIR}/finder-${PV}"

PATCHES=( "${FILESDIR}"/${PN}-3.4.28-skip-file-time-sort-tests.patch )

src_prepare() {
	default
	if use test; then
		cp "${FILESDIR}/autoload.php" "${S}/autoload-test.php" || die
	fi
}

src_install() {
	insinto "/usr/share/php/Symfony/Component/Finder"
	doins -r Comparator Exception Iterator
	doins *.php "${FILESDIR}"/autoload.php
	dodoc CHANGELOG.md README.md
}

src_test() {
	phpunit --bootstrap "${S}/autoload-test.php" || die 'test suite failed'
}
