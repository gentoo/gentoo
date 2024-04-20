# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1

DESCRIPTION="A stdlib like feel, and extra batteries. Hashing, Caching, Timing, Progress"
HOMEPAGE="
	https://github.com/Erotemic/ubelt/
	https://pypi.org/project/ubelt/
"
SRC_URI="
	https://github.com/Erotemic/${PN}/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

SLOT="0"
LICENSE="Apache-2.0"
KEYWORDS="~amd64 ~arm64 ~x86"

BDEPEND="
	test? (
		>=dev-python/numpy-1.19.2[${PYTHON_USEDEP}]
		>=dev-python/pygments-2.2.0[${PYTHON_USEDEP}]
		>=dev-python/python-dateutil-2.8.1[${PYTHON_USEDEP}]
		>=dev-python/requests-2.25.1[${PYTHON_USEDEP}]
		dev-python/xdoctest[${PYTHON_USEDEP}]
		>=dev-python/xxhash-1.0.1[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

EPYTEST_DESELECT=(
	tests/test_editable_modules.py::test_import_of_editable_install
	# relies on passwd home being equal to ${HOME}
	ubelt/util_path.py::userhome:0
)
