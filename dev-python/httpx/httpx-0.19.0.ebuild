# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Docs builder mkdocs not keyworded on all these arches yet
# DOCS_BUILDER="mkdocs"
# DOCS_DEPEND="dev-python/mkdocs-material"
# DOCS_AUTODOC=1
PYTHON_COMPAT=( python3_{8..10} )

inherit distutils-r1 # docs

DESCRIPTION="Fully-featured HTTP client which provides sync and async APIs"
HOMEPAGE="https://www.python-httpx.org/"
SRC_URI="https://github.com/encode/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 arm arm64 hppa ppc ppc64 ~riscv sparc x86"

RDEPEND="
	dev-python/certifi[${PYTHON_USEDEP}]
	dev-python/charset_normalizer[${PYTHON_USEDEP}]
	dev-python/sniffio[${PYTHON_USEDEP}]
	=dev-python/httpcore-0.13*[${PYTHON_USEDEP}]
	>=dev-python/rfc3986-1.3[${PYTHON_USEDEP}]
	<dev-python/rfc3986-2[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/brotlicffi[${PYTHON_USEDEP}]
		dev-python/cryptography[${PYTHON_USEDEP}]
		dev-python/h2[${PYTHON_USEDEP}]
		dev-python/pytest-asyncio[${PYTHON_USEDEP}]
		dev-python/trustme[${PYTHON_USEDEP}]
		dev-python/typing-extensions[${PYTHON_USEDEP}]
		dev-python/uvicorn[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

EPYTEST_DESELECT=(
	# Internet
	tests/client/test_proxies.py::test_async_proxy_close
	tests/client/test_proxies.py::test_sync_proxy_close
	# known to fail, unimportant test
	"tests/test_decoders.py::test_text_decoder[data3-iso-8859-1]"
	tests/models/test_responses.py::test_response_no_charset_with_iso_8859_1_content
)

python_prepare_all() {
	# increase timeout for slower systems
	sed -e 's/pool=/&10*/' -i tests/test_timeouts.py || die
	# trio does not support py3.10
	sed -e '/^import trio/d' -i tests/concurrency.py || die
	sed -e '/pytest.param("trio", marks=pytest.mark.trio)/d' -i tests/conftest.py || die
	distutils-r1_python_prepare_all
}
