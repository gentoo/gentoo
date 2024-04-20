# Copyright 2021-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1 pypi

DESCRIPTION="Extend rich functionality"
HOMEPAGE="
	https://github.com/pycontribs/enrich/
	https://pypi.org/project/enrich/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm64 ~riscv ~x86"

RDEPEND="
	dev-python/rich[${PYTHON_USEDEP}]
"
BDEPEND="
	dev-python/setuptools-scm[${PYTHON_USEDEP}]
	test? (
		dev-python/pytest-mock[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

EPYTEST_DESELECT=(
	# known breakage in dev-python/rich
	# https://github.com/Textualize/rich/issues/2172
	# https://github.com/pycontribs/enrich/issues/40
	src/enrich/test/test_console.py::test_rich_console_ex
)
