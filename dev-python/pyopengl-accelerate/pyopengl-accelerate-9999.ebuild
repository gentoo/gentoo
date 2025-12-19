# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..13} )

inherit distutils-r1

DESCRIPTION="Accelerate module for PyOpenGL"
HOMEPAGE="
	https://pyopengl.sourceforge.net/
	https://github.com/mcfletch/pyopengl/
	https://pypi.org/project/PyOpenGL-accelerate/
"

if [[ ${PV} = *9999* ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/mcfletch/pyopengl.git"
	S="${S}/accelerate"
else
	MY_P=pyopengl-release-${PV}
	SRC_URI="
		https://github.com/mcfletch/pyopengl/archive/release-${PV}.tar.gz
			-> ${MY_P}.gh.tar.gz
	"
	KEYWORDS="~amd64 ~x86"
	S=${WORKDIR}/${MY_P}/accelerate
fi

LICENSE="BSD"
SLOT="0"
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

src_prepare() {
	default

	touch requirements.txt || die

	eapply -p2 "${FILESDIR}/${PN}-3.1.8-gcc-14.patch"

	eapply -p1 "${FILESDIR}/${PN}-3.1.8-numpy-2.0.patch"
}

src_configure() {
	rm src/*.c || die

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
