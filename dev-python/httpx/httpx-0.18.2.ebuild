# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

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
KEYWORDS="amd64 arm arm64 ppc ppc64 sparc x86"

RDEPEND="
	dev-python/certifi[${PYTHON_USEDEP}]
	dev-python/sniffio[${PYTHON_USEDEP}]
	=dev-python/httpcore-0.13*[${PYTHON_USEDEP}]
	>=dev-python/rfc3986-1.3[${PYTHON_USEDEP}]
	<dev-python/rfc3986-2[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/brotlicffi[${PYTHON_USEDEP}]
		dev-python/cryptography[${PYTHON_USEDEP}]
		dev-python/hyper-h2[${PYTHON_USEDEP}]
		dev-python/pytest-asyncio[${PYTHON_USEDEP}]
		dev-python/trustme[${PYTHON_USEDEP}]
		dev-python/typing-extensions[${PYTHON_USEDEP}]
		dev-python/uvicorn[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

PATCHES=(
	# https://github.com/encode/httpx/pull/1781
	"${FILESDIR}"/${P}-big-endian.patch
)

python_prepare_all() {
	# trio is not currently in the tree
	sed -i '/^import trio/d' tests/concurrency.py || die
	sed -i '/pytest.param("trio", marks=pytest.mark.trio)/d' tests/conftest.py || die
	distutils-r1_python_prepare_all
}

python_test() {
	local deselect=(
		# Internet
		tests/client/test_proxies.py::test_async_proxy_close
		tests/client/test_proxies.py::test_sync_proxy_close
	)

	epytest ${deselect[@]/#/--deselect }
}
