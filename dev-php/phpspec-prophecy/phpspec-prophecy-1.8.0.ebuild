# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

MY_PN="prophecy"
MY_VENDOR="phpspec"

DESCRIPTION="Highly opinionated mocking framework"
HOMEPAGE="https://github.com/phpspec/prophecy"
SRC_URI="https://github.com/${MY_VENDOR}/${MY_PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86"
IUSE=""

S="${WORKDIR}/${MY_PN}-${PV}"

RDEPEND="dev-php/fedora-autoloader
	<dev-php/doctrine-instantiator-2
	<dev-php/phpdocumentor-reflection-docblock-4
	<dev-php/sebastian-comparator-3
	<dev-php/sebastian-recursion-context-4
	>=dev-lang/php-5.6:*"

src_install() {
	insinto /usr/share/php/${MY_VENDOR}/Prophecy
	doins -r src/Prophecy/*
	doins "${FILESDIR}/autoload.php"
}
