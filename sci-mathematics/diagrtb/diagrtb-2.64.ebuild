# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils fortran-2

DESCRIPTION="Calculation of some eigenvectors of a large real, symmetrical, matrix"
HOMEPAGE="http://ecole.modelisation.free.fr/modes.html"
SRC_URI="http://ecole.modelisation.free.fr/rtb2011.tar.gz -> ${P}.tar.gz"

LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="examples"
RESTRICT="mirror bindist"

S="${WORKDIR}"/Source_RTB2011

src_prepare() {
	cp "${FILESDIR}"/CMakeLists.txt . || die

	cmake-utils_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DEXAMPLES=$(usex examples)
	)

	cmake-utils_src_configure
}
