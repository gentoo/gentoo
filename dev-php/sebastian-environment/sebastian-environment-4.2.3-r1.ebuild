# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PN="${PN/sebastian-//}"

DESCRIPTION="Helps writing PHP code that has runtime-specific execution paths"
HOMEPAGE="https://github.com/sebastianbergmann/environment"
SRC_URI="https://github.com/sebastianbergmann/${MY_PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

S="${WORKDIR}/${MY_PN}-${PV}"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~s390 ~sparc ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="dev-php/fedora-autoloader
	>=dev-lang/php-7.1:*"
DEPEND="
	test? (
		${RDEPEND}
		dev-php/phpunit
	)"

PATCHES=(
	"${FILESDIR}/${PV}-0001-fix-fstat-call.patch"
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
	insinto /usr/share/php/SebastianBergmann/Environment
	doins -r src/*
	newins "${FILESDIR}"/autoload-"${PV}".php autoload.php
	dodoc README.md
}
