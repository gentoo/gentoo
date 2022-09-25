# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..10} )
inherit distutils-r1

DESCRIPTION="Python implementation of the Engine.IO realtime server"
HOMEPAGE="
	https://python-engineio.readthedocs.io/
	https://github.com/miguelgrinberg/python-engineio/
	https://pypi.org/project/python-engineio/"
SRC_URI="
	https://github.com/miguelgrinberg/python-engineio/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-python/aiohttp[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
	dev-python/websocket-client[${PYTHON_USEDEP}]
"
# Can use eventlet, werkzeug, or gevent, but no tests for werkzeug
# eventlet doesn't yet support Python 3.10, so let's work around it
BDEPEND="
	test? (
		$(python_gen_cond_dep '
			dev-python/eventlet[${PYTHON_USEDEP}]
		' python3_{8,9} )

		dev-python/gevent[${PYTHON_USEDEP}]
		dev-python/tornado[${PYTHON_USEDEP}]
		dev-python/websockets[${PYTHON_USEDEP}]
	)
"

EPYTEST_DESELECT=(
	# Both want websocket (server) which isn't strictly required and fails
	# because it can't find it. Think it needs right provider depending on
	# whether it chose gevent/eventlet/werkzeug. Not worth the effort.
	tests/common/test_server.py::TestServer::test_connect
	tests/common/test_server.py::TestServer::test_upgrades
)

distutils_enable_tests pytest
distutils_enable_sphinx docs \
	dev-python/alabaster

python_test() {
	if [[ ${EPYTHON} != python3.8 && ${EPYTHON} != python3.9 ]] ; then
		EPYTEST_IGNORE+=(
			tests/common/test_async_eventlet.py
		)

		EPYTEST_DESELECT+=(
			tests/common/test_server.py::TestServer::test_async_mode_eventlet
		)
	fi

	epytest
}
