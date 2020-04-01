# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

DESCRIPTION="Library for handling version information and constraints"
HOMEPAGE="https://github.com/phar-io/version"
SRC_URI="https://github.com/phar-io/version/archive/${PV}.tar.gz -> ${P}.tar.gz"

S="${WORKDIR}/version-${PV}"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~s390 ~sparc ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-lang/php:*
	dev-php/fedora-autoloader"
DEPEND="
	test? (
		${RDEPEND}
		dev-php/phpunit
	)"

PATCHES=(
	"${FILESDIR}/${PV}"-001-Fix-missing-name-warning.patch
)

src_prepare() {
	default
	if use test; then
		mkdir "${S}"/vendor
		cp "${FILESDIR}/${PV}"-autoload-test.php "${S}"/vendor/autoload.php || die
	fi
}

src_test() {
	phpunit --bootstrap vendor/autoload.php|| die "test suite failed"
}

src_install() {
	insinto /usr/share/php/PharIo/Version
	doins -r src/*
	newins "${FILESDIR}/${PV}"-autoload.php autoload.php
	dodoc README.md
}
