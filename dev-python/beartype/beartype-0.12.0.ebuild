# Copyright 2022-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} )

inherit distutils-r1

DESCRIPTION="Unbearably fast runtime type checking in pure Python"
HOMEPAGE="
	https://pypi.org/project/beartype/
	https://github.com/beartype/beartype
"
SRC_URI="
	https://github.com/beartype/beartype/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

BDEPEND="
	test? (
		dev-python/mypy[${PYTHON_USEDEP}]
		dev-python/numpy[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

EPYTEST_DESELECT=(
	# fragile performance test
	beartype_test/a00_unit/a90_decor/test_decorwrapper.py::test_wrapper_fail_obj_large
)
