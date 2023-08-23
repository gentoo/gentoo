# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( pypy3 python3_{10..12} )

inherit distutils-r1 pypi

DESCRIPTION="Correctly inflect words and numbers"
HOMEPAGE="
	https://pypi.org/project/inflect/
	https://github.com/jaraco/inflect/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 arm arm64 ~loong ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~arm64-macos ~ppc-macos ~x64-macos ~x64-solaris"

RDEPEND="
	>=dev-python/pydantic-1.9.1[${PYTHON_USEDEP}]
	dev-python/typing-extensions[${PYTHON_USEDEP}]
"
BDEPEND="
	>=dev-python/setuptools-scm-3.4.1[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest
