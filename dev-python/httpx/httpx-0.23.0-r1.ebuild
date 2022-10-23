# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Docs builder mkdocs not keyworded on all these arches yet
# DOCS_BUILDER="mkdocs"
# DOCS_DEPEND="dev-python/mkdocs-material"
# DOCS_AUTODOC=1
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( pypy3 python3_{8..11} )

inherit distutils-r1 optfeature # docs

DESCRIPTION="Fully-featured HTTP client which provides sync and async APIs"
HOMEPAGE="
	https://www.python-httpx.org/
	https://github.com/encode/httpx/
	https://pypi.org/project/httpx/
"
SRC_URI="
	https://github.com/encode/httpx/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 arm arm64 hppa ~ia64 ~loong ~mips ppc ppc64 ~riscv ~s390 sparc x86"
IUSE="cli"

RDEPEND="
	dev-python/certifi[${PYTHON_USEDEP}]
	dev-python/sniffio[${PYTHON_USEDEP}]
	=dev-python/httpcore-0.15*[${PYTHON_USEDEP}]
	>=dev-python/rfc3986-1.3[${PYTHON_USEDEP}]
	cli? (
		=dev-python/click-8*[${PYTHON_USEDEP}]
		=dev-python/pygments-2*[${PYTHON_USEDEP}]
		<dev-python/rich-13[${PYTHON_USEDEP}]
	)
"
BDEPEND="
	test? (
		dev-python/brotlicffi[${PYTHON_USEDEP}]
		dev-python/cryptography[${PYTHON_USEDEP}]
		dev-python/h2[${PYTHON_USEDEP}]
		dev-python/pytest-asyncio[${PYTHON_USEDEP}]
		dev-python/pytest-trio[${PYTHON_USEDEP}]
		dev-python/socksio[${PYTHON_USEDEP}]
		dev-python/trio[${PYTHON_USEDEP}]
		dev-python/trustme[${PYTHON_USEDEP}]
		dev-python/typing-extensions[${PYTHON_USEDEP}]
		dev-python/uvicorn[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

src_prepare() {
	local PATCHES=(
		"${FILESDIR}"/${P}-cgi.patch
	)

	# unpin deps
	sed -i -e 's:==[0-9.*]\+::' -e 's:,<[0-9.]\+::' setup.py || die
	if ! use cli; then
		sed -i -e '/console_scripts/d' setup.py || die
	fi
	distutils-r1_src_prepare
}

python_test() {
	local EPYTEST_DESELECT=(
		# Internet
		tests/client/test_proxies.py::test_async_proxy_close
		tests/client/test_proxies.py::test_sync_proxy_close
	)
	local EPYTEST_IGNORE=()

	use cli || EPYTEST_IGNORE+=(
		tests/test_main.py
	)

	epytest
}

pkg_postinst() {
	optfeature "HTTP/2 support" dev-python/h2
	optfeature "SOCKS proxy support" dev-python/socksio
	optfeature "Decoding for brotli compressed responses" dev-python/brotlicffi
}
