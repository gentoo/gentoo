# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_6 )

DISTUTILS_USE_SETUPTOOLS=rdepend

inherit distutils-r1 eutils

DESCRIPTION="The lightning-fast ASGI server"
HOMEPAGE="https://www.uvicorn.org/
	https://github.com/encode/uvicorn"
SRC_URI="https://github.com/encode/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
KEYWORDS="~amd64 ~x86"
SLOT="0"

IUSE="doc"

RDEPEND="
	dev-python/click[${PYTHON_USEDEP}]
	dev-python/h11[${PYTHON_USEDEP}]"

BDEPEND="doc? (
	dev-python/mkdocs
	dev-python/mkdocs-material )"

DEPEND="test? (
	dev-python/isort[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
	>=dev-python/uvloop-0.14.0[${PYTHON_USEDEP}]
	dev-python/wsproto[${PYTHON_USEDEP}]
	>=dev-python/websockets-6.0[${PYTHON_USEDEP}]
	>=dev-python/httptools-0.1.1[${PYTHON_USEDEP}] )"

distutils_enable_tests pytest

python_prepare_all() {
	# these tests fail to collect, likely because wsproto is out of date
	# ImportError: cannot import name 'ConnectionType'
	rm tests/protocols/test_websocket.py || die
	rm tests/protocols/test_http.py || die

	# AttributeError: module 'uvicorn.protocols.http' has no attribute 'h11_impl'
	sed -i -e 's:test_concrete_http_class:_&:' \
		tests/test_config.py || die

	# do not install LICENSE to /usr/
	sed -i -e '/data_files/d' setup.py || die

	distutils-r1_python_prepare_all
}

python_compile_all() {
	default
	if use doc; then
		mkdocs build || die "failed to make docs"
		HTML_DOCS="site"
	fi
}

pkg_postinst() {
	optfeature "asyncio event loop on top of libuv" dev-python/uvloop
	optfeature "websockets support using wsproto" dev-python/wsproto
	optfeature "websockets support using websockets" dev-python/websockets
	optfeature "httpstools package for http protocol" dev-python/httptools
}
