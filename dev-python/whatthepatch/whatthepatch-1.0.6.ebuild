# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..13} pypy3 )

inherit distutils-r1 pypi

DESCRIPTION="A patch parsing and application library."
HOMEPAGE="
	https://github.com/cscorley/whatthepatch/
	https://pypi.org/project/whatthepatch/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 arm64 ~ppc64 x86"

EPYTEST_DESELECT=(
	# the test measures performance of the patch parser together with test data
	# preparation, which can take long time in some interpreters, bug #907243
	tests/test_patch.py::PatchTestSuite::test_huge_patch
)

distutils_enable_tests pytest
