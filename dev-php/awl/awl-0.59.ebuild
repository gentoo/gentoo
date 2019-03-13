# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Andrew McMillan's Web Libraries"
HOMEPAGE="https://gitlab.com/davical-project/awl"
SRC_URI="https://www.davical.org/downloads/${PN}_${PV}.orig.tar.xz -> ${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

DEPEND="test? ( dev-php/phpunit )"
RDEPEND="dev-lang/php:*[pdo,postgres,xml]"

S="${WORKDIR}"

src_compile() {
	:
}

src_test() {
	phpunit tests/ || die "test suite failed"
}

src_install() {
	einstalldocs
	insinto /usr/share/php/${PN}
	doins -r dba inc
}
