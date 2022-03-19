# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Docs builder mkdocs not keyworded on all these arches yet
# DOCS_BUILDER="mkdocs"
# DOCS_DEPEND="dev-python/mkdocs-material"
# DOCS_AUTODOC=1
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..10} )
inherit distutils-r1 optfeature # docs

DESCRIPTION="Fully-featured HTTP client which provides sync and async APIs"
HOMEPAGE="https://www.python-httpx.org/"
SRC_URI="
	https://github.com/encode/${PN}/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~riscv ~sparc ~x86"
IUSE="cli"

RDEPEND="
	dev-python/certifi[${PYTHON_USEDEP}]
	dev-python/charset_normalizer[${PYTHON_USEDEP}]
	dev-python/sniffio[${PYTHON_USEDEP}]
	=dev-python/httpcore-0.14*[${PYTHON_USEDEP}]
	>=dev-python/rfc3986-1.3[${PYTHON_USEDEP}]
	<dev-python/rfc3986-2[${PYTHON_USEDEP}]
	cli? (
		=dev-python/click-8*[${PYTHON_USEDEP}]
		=dev-python/pygments-2*[${PYTHON_USEDEP}]
		<dev-python/rich-12[${PYTHON_USEDEP}]
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
	sed -i -e '/rich/s:==10[.][*]:<12:' setup.py || die
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

		# Result change in charset-normalizer-2.0.7+
		'tests/test_decoders.py::test_text_decoder[data3-iso-8859-1]'
		'tests/models/test_responses.py::test_response_no_charset_with_iso_8859_1_content'
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
