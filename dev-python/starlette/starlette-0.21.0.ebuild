# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( python3_{8..11} )

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
KEYWORDS="~amd64 ~x86"

# TODO: package python-multipart
RDEPEND="
	<dev-python/anyio-5[${PYTHON_USEDEP}]
	>=dev-python/anyio-3.4.0[${PYTHON_USEDEP}]
	>=dev-python/httpx-0.22.0[${PYTHON_USEDEP}]
	dev-python/itsdangerous[${PYTHON_USEDEP}]
	dev-python/jinja[${PYTHON_USEDEP}]
	$(python_gen_cond_dep '
		>=dev-python/typing-extensions-3.10.0[${PYTHON_USEDEP}]
	' 3.8 3.9)
	dev-python/pyyaml[${PYTHON_USEDEP}]
"
# brotli needed for consistent test output
BDEPEND="
	test? (
		|| (
			dev-python/brotlicffi[${PYTHON_USEDEP}]
			app-arch/brotli[python,${PYTHON_USEDEP}]
		)
		dev-python/trio[${PYTHON_USEDEP}]
	)
"

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

src_prepare() {
	# fix accept-encoding, as new support was added with newer versions
	sed -e '/accept-encoding/s/",/, br&/' -i tests/test_{websockets,requests}.py || die

	distutils-r1_src_prepare
}
