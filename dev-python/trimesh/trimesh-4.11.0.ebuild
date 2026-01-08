# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..13} )

inherit distutils-r1 optfeature

DESCRIPTION="Python library for loading and using triangular meshes"
HOMEPAGE="
	https://trimesh.org/
	https://github.com/mikedh/trimesh/
	https://pypi.org/project/trimesh/
"
SRC_URI="
	https://github.com/mikedh/${PN}/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"

RDEPEND="
	dev-python/charset-normalizer[${PYTHON_USEDEP}]
	dev-python/colorlog[${PYTHON_USEDEP}]
	dev-python/httpx[${PYTHON_USEDEP}]
	dev-python/jsonschema[${PYTHON_USEDEP}]
	dev-python/lxml[${PYTHON_USEDEP}]
	dev-python/networkx[${PYTHON_USEDEP}]
	>=dev-python/numpy-1.20[${PYTHON_USEDEP}]
	dev-python/pillow[${PYTHON_USEDEP}]
	dev-python/pycollada[${PYTHON_USEDEP}]
	dev-python/pyglet[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
	dev-python/scipy[${PYTHON_USEDEP}]
	>=dev-python/shapely-1.8.2[${PYTHON_USEDEP}]
	dev-python/svg-path[${PYTHON_USEDEP}]
	dev-python/sympy[${PYTHON_USEDEP}]
	dev-python/xxhash[${PYTHON_USEDEP}]
	dev-python/rtree[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/mapbox-earcut[${PYTHON_USEDEP}]
		dev-python/pillow[webp,${PYTHON_USEDEP}]
	)
"

EPYTEST_DESELECT=(
	# requires manifold3d
	tests/test_boolean.py::test_multiple_difference
	# timing nonsense
	tests/test_bounds.py::BoundsTest::test_obb_mesh_large
)
EPYTEST_IGNORE=(
	# require pyinstrument
	tests/test_sweep.py
)

EPYTEST_PLUGINS=()
: ${EPYTEST_TIMEOUT:=300}
EPYTEST_RERUNS=3
EPYTEST_XDIST=1

distutils_enable_tests pytest

python_test() {
	# We run tests in parallel, so avoid having n^2 threads in lapack
	# tests.
	local -x BLIS_NUM_THREADS=1
	local -x MKL_NUM_THREADS=1
	local -x OMP_NUM_THREADS=1
	local -x OPENBLAS_NUM_THREADS=1

	epytest
}

pkg_postinst() {
	optfeature_header "${PN} functionality can be extended by installing the following packages:"
	optfeature "making GUI applications with 3D stuff" dev-python/glooey
	optfeature "2D triangulations of polygons" dev-python/mapbox-earcut
	optfeature "loading a number of additional mesh formats" dev-python/meshio
	optfeature "figuring out how much memory we have" dev-python/psutil
	optfeature "marching cubes and other nice stuff" dev-python/scikit-image
}
