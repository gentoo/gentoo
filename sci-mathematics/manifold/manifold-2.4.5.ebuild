# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )
PYPI_PN=manifold3d
inherit cmake pypi python-single-r1

DESCRIPTION="Geometry library for topological robustness"
HOMEPAGE="https://github.com/elalish/manifold"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

IUSE="python"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

# tests not included in PyPI archive (but nanobind and quickhull are)
RESTRICT="test mirror"

RDEPEND="
	dev-cpp/tbb
	sci-mathematics/clipper2
	python? ( ${PYTHON_DEPS}
		$(python_gen_cond_dep '
			dev-python/numpy[${PYTHON_USEDEP}]
		')
	)
	"
DEPEND="
	media-libs/glm
	|| ( dev-cpp/cccl dev-util/nvidia-cuda-toolkit )
	${RDEPEND}"

src_prepare() {
	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DMANIFOLD_CBIND=OFF
		-DMANIFOLD_JSBIND=OFF
		-DMANIFOLD_EXPORT=OFF
		-DMANIFOLD_PAR=TBB
		-DMANIFOLD_PYBIND=$(usex python)
		-DMANIFOLD_TEST=OFF
	)
	cmake_src_configure
}
