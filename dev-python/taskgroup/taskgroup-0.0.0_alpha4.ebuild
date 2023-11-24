# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=flit
# py3.11: this is a backport to py3.10, please do not add more targets
PYTHON_COMPAT=( pypy3 python3_10 )

inherit distutils-r1 pypi

DESCRIPTION="Backport of asyncio.TaskGroup, asyncio.Runner and asyncio.timeout"
HOMEPAGE="
	https://github.com/graingert/taskgroup/
	https://pypi.org/project/taskgroup/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"

RDEPEND="
	dev-python/exceptiongroup[${PYTHON_USEDEP}]
	<dev-python/typing-extensions-5[${PYTHON_USEDEP}]
	>=dev-python/typing-extensions-4.8[${PYTHON_USEDEP}]
"
