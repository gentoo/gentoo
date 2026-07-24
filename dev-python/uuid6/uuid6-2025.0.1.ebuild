# Copyright 2025-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{12..15} )

inherit distutils-r1 pypi

DESCRIPTION="New time-based UUID formats which are suited for use as a database key"
HOMEPAGE="
	https://github.com/oittaa/uuid6-python/
	https://pypi.org/project/uuid6/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm64 ~x86"

BDEPEND="
	dev-python/setuptools-scm[${PYTHON_USEDEP}]
"

EPYTEST_PLUGINS=()
distutils_enable_tests pytest

EPYTEST_DESELECT=(
	# fragile to timing
	# https://github.com/oittaa/uuid6-python/issues/227
	test/test_uuid6.py::UUIDTests::test_time
)
