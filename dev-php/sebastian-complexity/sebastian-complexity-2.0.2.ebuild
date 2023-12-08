# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="${PN/sebastian-//}"

DESCRIPTION="Library for calculating the complexity of PHP code units"
HOMEPAGE="https://phpunit.de"
SRC_URI="https://github.com/sebastianbergmann/${MY_PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~s390 ~sparc ~x86"
IUSE=""

S="${WORKDIR}/${MY_PN}-${PV}"

RDEPEND="dev-php/fedora-autoloader
	dev-php/nikic-php-parser
	>=dev-lang/php-7.3:*"

src_install() {
	insinto /usr/share/php/SebastianBergmann/Complexity
	doins -r src/*
	newins "${FILESDIR}/autoload-2.0.2.php" autoload.php
}
