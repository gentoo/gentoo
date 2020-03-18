# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit vcs-snapshot toolchain-funcs

COMMIT="aeb0266b3a89f32c390dff51cb73a454d5d7a745"
DESCRIPTION="an extension to the Boost.MPL library"
HOMEPAGE="https://github.com/quinoacomputing/BoostMPLCartesianProduct"
SRC_URI="https://github.com/quinoacomputing/BoostMPLCartesianProduct/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="Boost-1.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

DEPEND="dev-libs/boost"
RDEPEND="${DEPEND}"

src_compile() {
	use test || return
	local i
	for i in $(find libs/mpl -name "*.cpp"); do
		echo $(tc-getCXX) ${CXXFLAGS} -I. "$i" -o "${i%.cpp}"
		$(tc-getCXX) ${CXXFLAGS} -I. "$i" -o "${i%.cpp}" || die
	done
}

src_test() {
	local i
	for i in $(find libs/mpl -name "*.cpp"); do
		echo "${i%.cpp}"
		"${i%.cpp}" || die
	done
}

src_install() {
	dodoc readme.txt
	insinto /usr/include/boost/mpl
	doins boost/mpl/cartesian_product.hpp
}
