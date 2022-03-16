# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..10} )

inherit distutils-r1

DESCRIPTION="The little ASGI framework that shines"
HOMEPAGE="https://www.starlette.io/"
SRC_URI="
	https://github.com/encode/starlette/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	<dev-python/anyio-5[${PYTHON_USEDEP}]
	>=dev-python/anyio-3.4.0[${PYTHON_USEDEP}]
	dev-python/itsdangerous[${PYTHON_USEDEP}]
	$(python_gen_cond_dep '
		dev-python/typing-extensions[${PYTHON_USEDEP}]
	' 3.8 3.9 )
"
BDEPEND="
	test? (
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
