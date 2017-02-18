# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="zetacomponents-unit-test Component"
HOMEPAGE="https://github.com/zetacomponents/UnitTest"
SRC_URI="${HOMEPAGE}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-lang/php:*"

S="${WORKDIR}/UnitTest-${PV}"

src_install() {
	insinto "/usr/share/php/zetacomponents/UnitTest"
	doins -r src/. "${FILESDIR}"/autoload.php
}
