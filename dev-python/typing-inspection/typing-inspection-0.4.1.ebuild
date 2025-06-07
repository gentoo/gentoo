# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( pypy3_11 python3_{11..14} )

inherit distutils-r1 pypi

DESCRIPTION="Runtime typing introspection tools"
HOMEPAGE="
	https://github.com/pydantic/typing-inspection/
	https://pypi.org/project/typing-inspection/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 arm arm64 ~loong ~ppc ppc64 ~riscv ~s390 ~sparc ~x86"

RDEPEND="
	>=dev-python/typing-extensions-4.12.0[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest
