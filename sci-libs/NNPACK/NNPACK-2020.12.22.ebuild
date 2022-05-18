# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )
inherit cmake python-any-r1

CommitId=c07e3a0400713d546e0dea2d5466dd22ea389c73

DESCRIPTION="acceleration package for neural network computations"
HOMEPAGE="https://github.com/Maratyszcza/NNPACK/"
SRC_URI="https://github.com/Maratyszcza/${PN}/archive/${CommitId}.tar.gz
	-> ${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE=test
RESTRICT="test" # consuming too much CPU

RDEPEND="
	dev-libs/pthreadpool
	dev-libs/cpuinfo
"
DEPEND="${RDEPEND}
	dev-libs/FP16
	dev-libs/FXdiv
	dev-libs/psimd
"
BDEPEND="
	${PYTHON_DEPS}
	test? ( dev-cpp/gtest )
	$(python_gen_any_dep '
		dev-python/PeachPy[${PYTHON_USEDEP}]
	')
"

S="${WORKDIR}"/${PN}-${CommitId}

PATCHES=( "${FILESDIR}"/${P}-gentoo.patch )

python_check_deps() {
	python_has_version "dev-python/PeachPy[${PYTHON_USEDEP}]"
}

src_configure() {
	local mycmakeargs=(
		-DNNPACK_BUILD_TESTS=$(usex test ON OFF)
	)
	cmake_src_configure
}
