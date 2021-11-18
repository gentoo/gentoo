# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )
inherit distutils-r1

COMMIT="99acac598682b45be98094216f7db223c1fdf5f2"

DESCRIPTION="Lightning-fast ASGI server implementation"
HOMEPAGE="https://www.uvicorn.org/"
SRC_URI="https://github.com/encode/${PN}/archive/${COMMIT}.tar.gz -> ${P}.gh.tar.gz"
S="${WORKDIR}/${PN}-${COMMIT}"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ppc ppc64 ~sparc x86"

RDEPEND="
	>=dev-python/asgiref-3.4.0[${PYTHON_USEDEP}]
	>=dev-python/click-7.0[${PYTHON_USEDEP}]
	>=dev-python/h11-0.8[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/cryptography[${PYTHON_USEDEP}]
		dev-python/httpx[${PYTHON_USEDEP}]
		dev-python/pytest-asyncio[${PYTHON_USEDEP}]
		dev-python/pytest-mock[${PYTHON_USEDEP}]
		dev-python/python-dotenv[${PYTHON_USEDEP}]
		dev-python/pyyaml[${PYTHON_USEDEP}]
		dev-python/trustme[${PYTHON_USEDEP}]
		>=dev-python/websockets-10.0[${PYTHON_USEDEP}]
		dev-python/watchgod[${PYTHON_USEDEP}]
		dev-python/wsproto[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

EPYTEST_DESELECT=(
	# too long path for unix socket
	tests/test_config.py::test_bind_unix_socket_works_with_reload_or_workers
	# need unpackaged httptools
	"tests/middleware/test_logging.py::test_trace_logging_on_http_protocol[httptools]"
)
