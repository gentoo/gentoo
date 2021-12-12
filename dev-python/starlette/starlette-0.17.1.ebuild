# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8,9,10} )
inherit distutils-r1

DESCRIPTION="The little ASGI framework that shines"
HOMEPAGE="https://www.starlette.io/"
SRC_URI="https://github.com/encode/starlette/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"

# Needs fixing with trio deprecations (dies on ModuleWithDeprecations)
RESTRICT="test"

RDEPEND="dev-python/anyio[${PYTHON_USEDEP}]
	dev-python/itsdangerous[${PYTHON_USEDEP}]"
BDEPEND="test? ( dev-python/trio[${PYTHON_USEDEP}] )"

EPYTEST_IGNORE=(
	# Unpackaged 'databases' dependency
	tests/test_database.py

	# Unpackaged 'multipart' dependency
	tests/test_formparsers.py
)

EPYTEST_DESELECT=(
	# Unpackaged 'multipart' dependency
	tests/test_requests.py::test_request_form_urlencoded
)

distutils_enable_tests pytest
