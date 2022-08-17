# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..10} )

inherit distutils-r1

EGIT_COMMIT="227f9c66976d9f5dadf62b9a97e6beaec84831ca"
DESCRIPTION="Accelerate module for PyOpenGL"
HOMEPAGE="
	http://pyopengl.sourceforge.net/
	https://github.com/mcfletch/pyopengl/
	https://pypi.org/project/PyOpenGL-accelerate/"
SRC_URI="
	https://github.com/mcfletch/pyopengl/archive/${EGIT_COMMIT}.tar.gz
		-> pyopengl-${EGIT_COMMIT}.gh.tar.gz"
S=${WORKDIR}/pyopengl-${EGIT_COMMIT}/accelerate

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"
IUSE=""

RDEPEND="dev-python/pyopengl[${PYTHON_USEDEP}]"
BDEPEND="
	test? (
		dev-python/numpy[${PYTHON_USEDEP}]
	)"

distutils_enable_tests pytest

python_test() {
	cd "${T}" || die
	epytest "${S}"/tests
}
