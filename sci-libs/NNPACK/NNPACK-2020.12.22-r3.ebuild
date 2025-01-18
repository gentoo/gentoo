# Copyright 2022-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )
inherit cmake python-single-r1

CommitId=c07e3a0400713d546e0dea2d5466dd22ea389c73

DESCRIPTION="acceleration package for neural network computations"
HOMEPAGE="https://github.com/Maratyszcza/NNPACK/"
SRC_URI="https://github.com/Maratyszcza/${PN}/archive/${CommitId}.tar.gz
	-> ${P}.tar.gz"

S="${WORKDIR}"/${PN}-${CommitId}

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE=test
RESTRICT="test" # consuming too much CPU
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="
	${PYTHON_DEPS}
	dev-libs/pthreadpool
	dev-libs/cpuinfo
	$(python_gen_cond_dep '
		<=dev-libs/FP16-2024.05.27[${PYTHON_USEDEP}]
		dev-python/peachpy[${PYTHON_USEDEP}]
	')
"
DEPEND="${RDEPEND}
	dev-libs/FXdiv
	dev-libs/psimd
"
BDEPEND="
	${RDEPEND}
	test? ( dev-cpp/gtest )
"

PATCHES=( "${FILESDIR}"/${P}-gentoo.patch )

src_prepare() {
	sed -i -e "/-O/d" CMakeLists.txt || die
	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DNNPACK_BUILD_TESTS=$(usex test ON OFF)
	)
	cmake_src_configure
}
