# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..10} )

inherit distutils-r1

DESCRIPTION="A supersonic micro-framework for building cloud APIs"
HOMEPAGE="
	https://falconframework.org/
	https://pypi.org/project/falcon/
	https://github.com/falconry/falcon/
"
SRC_URI="
	https://github.com/falconry/${PN}/archive/${PV}.tar.gz
		-> ${P}.tar.gz
"

LICENSE="Apache-2.0 MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

BDEPEND="
	dev-python/cython[${PYTHON_USEDEP}]
	test? (
		dev-python/aiofiles[${PYTHON_USEDEP}]
		dev-python/cbor2[${PYTHON_USEDEP}]
		dev-python/httpx[${PYTHON_USEDEP}]
		dev-python/msgpack[${PYTHON_USEDEP}]
		dev-python/pytest-asyncio[${PYTHON_USEDEP}]
		dev-python/pyyaml[${PYTHON_USEDEP}]
		dev-python/uvicorn[${PYTHON_USEDEP}]
		dev-python/websockets[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

python_test() {
	local EPYTEST_DESELECT=(
		# uwsgi seems to be broken/incompatible
		'tests/test_wsgi_servers.py::TestWSGIServer::test_get[uwsgi]'
		'tests/test_wsgi_servers.py::TestWSGIServer::test_get_deprecated[uwsgi]'
		'tests/test_wsgi_servers.py::TestWSGIServer::test_post_multipart_form[uwsgi]'
		'tests/test_wsgi_servers.py::TestWSGIServer::test_static_file[uwsgi]'
		'tests/test_wsgi_servers.py::TestWSGIServer::test_static_file_byte_range[uwsgi-'
	)

	local EPYTEST_IGNORE=(
		# mujson is unpackaged, test-only dep
		tests/test_media_handlers.py
	)

	rm -rf falcon || die
	# needed because servers are spawned via /usr/bin/python*
	local -x PYTHONPATH=${BUILD_DIR}/install$(python_get_sitedir):${PYTHONPATH}
	epytest tests
}
