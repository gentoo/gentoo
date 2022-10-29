# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..11} )

inherit distutils-r1 virtualx

MY_P=python-${P}
DESCRIPTION="An ultra fast cross-platform multiple screenshots module in python using ctypes"
HOMEPAGE="
	https://github.com/BoboTiG/python-mss/
	https://pypi.org/project/mss/
"
SRC_URI="
	https://github.com/BoboTiG/python-mss/archive/v${PV}.tar.gz
		-> ${MY_P}.gh.tar.gz
"
S=${WORKDIR}/${MY_P}

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~riscv ~x86"

BDEPEND="
	test? (
		dev-python/flaky[${PYTHON_USEDEP}]
		dev-python/wheel[${PYTHON_USEDEP}]
		sys-process/lsof
	)
"

distutils_enable_tests pytest
distutils_enable_sphinx docs/source dev-python/sphinx_rtd_theme

EPYTEST_DESELECT=(
	# upstream tests for self-build, apparently broken by setuptools
	# issuing deprecation warnings
	mss/tests/test_setup.py
)

src_test() {
	virtx distutils-r1_src_test
}
