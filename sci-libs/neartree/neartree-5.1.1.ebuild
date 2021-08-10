# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_P="NearTree-${PV}"
inherit cmake

DESCRIPTION="Function library efficiently solving the Nearest Neighbor Problem"
HOMEPAGE="http://neartree.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 ppc x86 ~amd64-linux ~x86-linux"

RDEPEND="dev-libs/cvector"
DEPEND="${RDEPEND}"

DOCS=( README_NearTree.txt )

src_prepare() {
	cp "${FILESDIR}"/CMakeLists.txt . || die
	cmake_src_prepare
}
