# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYPI_VERIFY_REPO=https://github.com/borntyping/python-colorlog
PYTHON_COMPAT=( pypy3_11 python3_{11..14} )

inherit distutils-r1 pypi

DESCRIPTION="Log formatting with colors"
HOMEPAGE="
	https://pypi.org/project/colorlog/
	https://github.com/borntyping/python-colorlog/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~loong ~riscv ~x86"

EPYTEST_PLUGINS=()
distutils_enable_tests pytest
