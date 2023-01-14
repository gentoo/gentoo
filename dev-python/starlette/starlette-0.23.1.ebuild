# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( pypy3 python3_{9..11} )

inherit distutils-r1

DESCRIPTION="The little ASGI framework that shines"
HOMEPAGE="
	https://www.starlette.io/
	https://github.com/encode/starlette/
	https://pypi.org/project/starlette/
"
SRC_URI="
	https://github.com/encode/starlette/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~loong ~ppc ~ppc64 ~riscv ~x86"

RDEPEND="
	<dev-python/anyio-5[${PYTHON_USEDEP}]
	>=dev-python/anyio-3.4.0[${PYTHON_USEDEP}]
	>=dev-python/httpx-0.22.0[${PYTHON_USEDEP}]
	dev-python/itsdangerous[${PYTHON_USEDEP}]
	dev-python/jinja[${PYTHON_USEDEP}]
	dev-python/python-multipart[${PYTHON_USEDEP}]
	dev-python/pyyaml[${PYTHON_USEDEP}]
	$(python_gen_cond_dep '
		>=dev-python/typing-extensions-3.10.0[${PYTHON_USEDEP}]
	' 3.8 3.9)
"
BDEPEND="
	test? (
		dev-python/trio[${PYTHON_USEDEP}]
	)
"

EPYTEST_IGNORE=(
	# Unpackaged 'databases' dependency
	tests/test_database.py
)

distutils_enable_tests pytest
