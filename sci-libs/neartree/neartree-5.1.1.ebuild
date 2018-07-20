# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils

MY_PN=NearTree
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Function library efficiently solving the Nearest Neighbor Problem"
HOMEPAGE="http://neartree.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.gz -> ${P}.tar.gz"
LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 ppc x86 ~amd64-linux ~x86-linux"
IUSE="static-libs"

RDEPEND="dev-libs/cvector"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	cp "${FILESDIR}"/CMakeLists.txt . || die
	cmake-utils_src_prepare
}

src_configure() {
	local mycmakeargs=( -DDOC_DIR="${EPREFIX}/usr/share/doc/${PF}" )
	cmake-utils_src_configure
}
