# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} )

inherit distutils-r1 virtualx

MY_P=python-${P}
DESCRIPTION="An ultra fast cross-platform multiple screenshots module in python using ctypes"
HOMEPAGE="
	https://github.com/BoboTiG/python-mss/
	https://pypi.org/project/mss/
"
# docs are missing in sdist, as of 8.0.2
# https://github.com/BoboTiG/python-mss/pull/240
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
		sys-process/lsof
	)
"

distutils_enable_tests pytest
distutils_enable_sphinx docs/source dev-python/sphinx-rtd-theme

EPYTEST_IGNORE=(
	# upstream tests for self-build, apparently broken by setuptools
	# issuing deprecation warnings
	mss/tests/test_setup.py
)

EPYTEST_DESELECT=(
	# unreliable `lsof -U | grep ...` tests
	mss/tests/test_leaks.py
)

src_prepare() {
	sed -i -e '/--cov/d' setup.cfg || die
	distutils-r1_src_prepare
}

src_test() {
	virtx distutils-r1_src_test
}
