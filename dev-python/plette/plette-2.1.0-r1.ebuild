# Copyright 2022-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( pypy3_11 python3_{11..14} )

inherit distutils-r1 pypi

DESCRIPTION="Structured Pipfile and Pipfile.lock models"
HOMEPAGE="
	https://github.com/sarugaku/plette/
	https://pypi.org/project/plette/
"

LICENSE="ISC"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~riscv"

RDEPEND="
	dev-python/tomlkit[${PYTHON_USEDEP}]
"

EPYTEST_PLUGINS=()
distutils_enable_tests pytest
