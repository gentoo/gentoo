# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..13} )

inherit distutils-r1 pypi

DESCRIPTION="Accelerate module for PyOpenGL"
HOMEPAGE="
	https://pyopengl.sourceforge.net/
	https://github.com/mcfletch/pyopengl/
	https://pypi.org/project/PyOpenGL-accelerate/
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="numpy"

DEPEND="
	numpy? (
		dev-python/numpy:=[${PYTHON_USEDEP}]
	)
"
RDEPEND="
	${DEPEND}
	dev-python/pyopengl[${PYTHON_USEDEP}]
"
BDEPEND="
	dev-python/cython[${PYTHON_USEDEP}]
"

EPYTEST_PLUGINS=()
distutils_enable_tests pytest

PATCHES=(
	"${FILESDIR}"/pyopengl-accelerate-3.1.9-cpython3.1.0.patch
)

src_configure() {
	if ! use numpy; then
		cat > "${T}"/numpy.py <<-EOF || die
			raise ImportError("building numpy extension disabled")
		EOF
	fi
}

python_compile() {
	local -x PYTHONPATH=${T}:${PYTHONPATH}
	distutils-r1_python_compile
}

python_test() {
	cd "${T}" || die
	epytest "${S}"/tests
}
