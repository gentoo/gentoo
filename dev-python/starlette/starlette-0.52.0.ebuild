# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( pypy3_11 python3_{11..14} )

inherit distutils-r1

MY_P=${P/_p/.post}
DESCRIPTION="The little ASGI framework that shines"
HOMEPAGE="
	https://www.starlette.io/
	https://github.com/Kludex/starlette/
	https://pypi.org/project/starlette/
"
# no docs or tests in sdist, as of 0.27.0
SRC_URI="
	https://github.com/Kludex/starlette/archive/${PV/_p/.post}.tar.gz
		-> ${MY_P}.gh.tar.gz
"
S=${WORKDIR}/${MY_P}

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"

RDEPEND="
	<dev-python/anyio-5[${PYTHON_USEDEP}]
	>=dev-python/anyio-3.6.2[${PYTHON_USEDEP}]
	<dev-python/httpx-0.29[${PYTHON_USEDEP}]
	>=dev-python/httpx-0.22.0[${PYTHON_USEDEP}]
	dev-python/itsdangerous[${PYTHON_USEDEP}]
	dev-python/jinja2[${PYTHON_USEDEP}]
	>=dev-python/python-multipart-0.0.18[${PYTHON_USEDEP}]
	dev-python/pyyaml[${PYTHON_USEDEP}]
	$(python_gen_cond_dep '
		>=dev-python/typing-extensions-3.10.0[${PYTHON_USEDEP}]
	' 3.11)
"
BDEPEND="
	test? (
		>=dev-python/pytest-8[${PYTHON_USEDEP}]
		dev-python/trio[${PYTHON_USEDEP}]
	)
"

EPYTEST_PLUGINS=( anyio )
: ${EPYTEST_TIMEOUT:-180}
distutils_enable_tests pytest

EPYTEST_IGNORE=(
	# Unpackaged 'databases' dependency
	tests/test_database.py
)
