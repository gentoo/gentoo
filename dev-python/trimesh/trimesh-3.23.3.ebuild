# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..11} )

inherit distutils-r1 multiprocessing optfeature

DESCRIPTION="Python library for loading and using triangular meshes"
HOMEPAGE="
	https://trimsh.org/
	https://github.com/mikedh/trimesh/
	https://pypi.org/project/trimesh/
"
SRC_URI="
	https://github.com/mikedh/${PN}/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm64 ~x86"

RDEPEND="
	dev-python/chardet[${PYTHON_USEDEP}]
	dev-python/colorlog[${PYTHON_USEDEP}]
	dev-python/jsonschema[${PYTHON_USEDEP}]
	dev-python/lxml[${PYTHON_USEDEP}]
	dev-python/networkx[${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/pillow[${PYTHON_USEDEP}]
	dev-python/pycollada[${PYTHON_USEDEP}]
	dev-python/pyglet[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
	dev-python/scipy[${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]
	>=dev-python/shapely-1.8.2[${PYTHON_USEDEP}]
	dev-python/svg-path[${PYTHON_USEDEP}]
	dev-python/sympy[${PYTHON_USEDEP}]
	dev-python/xxhash[${PYTHON_USEDEP}]
	sci-libs/rtree[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/pytest-xdist[${PYTHON_USEDEP}]
		dev-python/mapbox_earcut[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

python_test() {
	epytest -n "$(makeopts_jobs)" --dist=worksteal
}

pkg_postinst() {
	optfeature_header "${PN} functionality can be extended by installing the following packages:"
	optfeature "making GUI applications with 3D stuff" dev-python/glooey
	optfeature "2D triangulations of polygons" dev-python/mapbox_earcut
	optfeature "loading a number of additional mesh formats" dev-python/meshio
	optfeature "figuring out how much memory we have" dev-python/psutil
	optfeature "marching cubes and other nice stuff" sci-libs/scikit-image
}
