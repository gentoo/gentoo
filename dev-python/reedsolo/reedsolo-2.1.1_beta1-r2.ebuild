# Copyright 2021-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1 pypi

DESCRIPTION="Python Reed Solomon encoder/decoder"
HOMEPAGE="
	https://github.com/tomerfiliba-org/reedsolomon/
	https://pypi.org/project/reedsolo/
"

LICENSE="|| ( Unlicense MIT-0 )"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 x86"
IUSE="+native-extensions"

BDEPEND="
	>=dev-python/cython-3[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest

src_prepare() {
	sed -i -e '/pytest-cov/d' pyproject.toml || die
	distutils-r1_src_prepare
}

python_compile() {
	local DISTUTILS_ARGS=()
	if use native-extensions && [[ ${EPYTHON} != pypy3 ]] ; then
		DISTUTILS_ARGS+=(
			# TODO: switch to --cythonize once we're on cython-3
			--cythonize
		)
	fi
	distutils-r1_python_compile
}
