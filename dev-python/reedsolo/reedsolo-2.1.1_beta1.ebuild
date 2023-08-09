# Copyright 2021-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..11} )

inherit distutils-r1 pypi

DESCRIPTION="Python Reed Solomon encoder/decoder"
HOMEPAGE="
	https://github.com/tomerfiliba-org/reedsolomon/
	https://pypi.org/project/reedsolo/
"

LICENSE="|| ( Unlicense MIT-0 )"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"
IUSE="+native-extensions"

distutils_enable_tests pytest

src_prepare() {
	sed -i -e '/pytest-cov/d' pyproject.toml || die
	distutils-r1_src_prepare
}

src_configure() {
	if use native-extensions; then
		DISTUTILS_ARGS=(
			# TODO: switch to --cythonize once we're on cython-3
			--native-compile
		)
	fi
}
