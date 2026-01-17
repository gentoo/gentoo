# Copyright 2021-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..14} )

inherit distutils-r1

MY_P="jq.py-${PV}"
DESCRIPTION="Python bindings for jq"
HOMEPAGE="
	https://github.com/mwilliamson/jq.py/
	https://pypi.org/project/jq/
"
# pypi sdist is missing .pyx
SRC_URI="
	https://github.com/mwilliamson/jq.py/archive/${PV}.tar.gz
		-> ${MY_P}.gh.tar.gz
"
S=${WORKDIR}/${MY_P}

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"

# Minimum versions of jq + onigurama are from setup.py's bundled versions
DEPEND="
	>=app-misc/jq-1.8.0:=
	>=dev-libs/oniguruma-6.9.8:=
"
RDEPEND="
	${DEPEND}
"
BDEPEND="
	dev-python/cython[${PYTHON_USEDEP}]
"

EPYTEST_PLUGINS=()
distutils_enable_tests pytest

python_compile() {
	local -x JQPY_USE_SYSTEM_LIBS=1

	distutils-r1_python_compile
}
