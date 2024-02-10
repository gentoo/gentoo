# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1

MY_P=line_profiler-${PV}
DESCRIPTION="Line-by-line profiler"
HOMEPAGE="
	https://github.com/pyutils/line_profiler/
	https://pypi.org/project/line-profiler/
"
SRC_URI="
	https://github.com/pyutils/line_profiler/archive/v${PV}.tar.gz
		-> ${MY_P}.gh.tar.gz
"
S=${WORKDIR}/${MY_P}

SLOT="0"
LICENSE="BSD"
KEYWORDS="~amd64 ~arm64 ~x86"

RDEPEND="
	dev-python/ipython[${PYTHON_USEDEP}]
"
BDEPEND="
	dev-python/cython[${PYTHON_USEDEP}]
	test? (
		dev-python/coverage[${PYTHON_USEDEP}]
		dev-python/ubelt[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

export LINE_PROFILER_BUILD_METHOD=cython

python_test() {
	cd tests || die
	epytest
}
