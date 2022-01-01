# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Fedora's Static PSR-4, PSR-0, and classmap autoloader"
HOMEPAGE="https://github.com/php-fedora/autoloader"
SRC_URI="https://github.com/php-fedora/autoloader/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~hppa ~ia64 ppc ppc64 ~s390 sparc x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="dev-lang/php:*"
DEPEND="
	test? (
		${RDEPEND}
		dev-php/phpunit )"

S="${WORKDIR}/autoloader-${PV}"

src_install() {
	insinto "/usr/share/php/Fedora/Autoloader"
	doins -r src/.
	dodoc CHANGELOG.md README.md
}

src_test() {
	phpunit || die "test suite failed"
}
