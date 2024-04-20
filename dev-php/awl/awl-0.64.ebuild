# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Andrew McMillan's Web Libraries"
HOMEPAGE="https://gitlab.com/davical-project/awl"
SRC_URI="https://www.davical.org/downloads/${PN}_${PV}.orig.tar.xz -> ${P}.tar.xz"

LICENSE="GPL-2 GPL-2+ GPL-3+ LGPL-2+ LGPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="dev-lang/php:*[pdo,xml]"

S="${WORKDIR}"

PATCHES=( "${FILESDIR}/${P}-php8.x-compat.patch" )

src_compile() {
	:
}

src_install() {
	einstalldocs
	insinto /usr/share/php/${PN}
	doins -r dba inc
}
