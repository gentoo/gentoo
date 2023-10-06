# Copyright 2021-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1

MY_P="jq.py-${PV}"
DESCRIPTION="Python bindings for jq"
HOMEPAGE="
	https://github.com/mwilliamson/jq.py/
	https://pypi.org/project/jq/
"
SRC_URI="
	https://github.com/mwilliamson/jq.py/archive/${PV}.tar.gz
		-> ${MY_P}.gh.tar.gz
"
S=${WORKDIR}/${MY_P}

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="amd64 ~x86"

# Minimum versions of jq + onigurama are from setup.py's bundled versions
RDEPEND="
	>=app-misc/jq-1.7:=
	>=dev-libs/oniguruma-6.9.8:=
"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-python/cython[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest

python_compile() {
	local -x JQPY_USE_SYSTEM_LIBS=1

	# Cython compilation isn't part of setup.py, so do it manually
	"${EPYTHON}" -m cython -3 jq.pyx -o jq.c || die
	distutils-r1_python_compile
}
