# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake fortran-2

DESCRIPTION="Calculate Tirion's model from pdb structures"
HOMEPAGE="http://ecole.modelisation.free.fr/modes.html"
SRC_URI="http://ecole.modelisation.free.fr/enm2011.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}"/Source_ENM2011

LICENSE="CeCILL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="examples"

BDEPEND=">=dev-build/cmake-3.31"

src_prepare() {
	cp "${FILESDIR}"/CMakeLists.txt . || die

	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DEXAMPLES=$(usex examples)
	)

	cmake_src_configure
}
