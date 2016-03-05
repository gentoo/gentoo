# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

KMNAME="kactivities"
inherit kde4-base

DESCRIPTION="KDE Activity Manager Daemon"
KEYWORDS="amd64 ~arm ~ppc ~ppc64 ~x86 ~x86-fbsd ~amd64-linux ~x86-linux"
IUSE=""

RDEPEND="
	!<kde-base/kactivities-4.13.3-r1
	!kde-frameworks/kactivities
"

S=${WORKDIR}/${KMNAME}-${PV}

src_configure() {
	local mycmakeargs=(
		-DCMAKE_SKIP_RPATH=ON
		-DWITH_NepomukCore=OFF
	)
	kde4-base_src_configure
}

src_install() {
	dobin "${BUILD_DIR}/src/service/${PN}"
}
