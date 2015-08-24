# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit cmake-utils

DESCRIPTION="Perpetual date converter from gregorian to poee calendar"
HOMEPAGE="https://github.com/bo0ts/ddate"
SRC_URI="https://github.com/bo0ts/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="!<sys-apps/util-linux-2.20
	!<sys-apps/util-linux-2.23[ddate]"
DEPEND="${RDEPEND}"

src_prepare() {
	sed -i -e '/gzip/d' CMakeLists.txt || die
}

src_install() {
	dobin "${CMAKE_BUILD_DIR}"/${PN}
	doman ${PN}.1
	dodoc README.org
}
