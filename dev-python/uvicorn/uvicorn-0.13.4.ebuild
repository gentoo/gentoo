# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )
# entry points are used
DISTUTILS_USE_SETUPTOOLS=rdepend

inherit distutils-r1

DESCRIPTION="Lightning-fast ASGI server implementation"
HOMEPAGE="https://www.uvicorn.org/"
SRC_URI="https://github.com/encode/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	=dev-python/click-7*[${PYTHON_USEDEP}]
	>=dev-python/h11-0.8[${PYTHON_USEDEP}]
	$(python_gen_cond_dep 'dev-python/typing-extensions[${PYTHON_USEDEP}]' python3_7)
"
BDEPEND="
	test? (
		dev-python/cryptography[${PYTHON_USEDEP}]
		dev-python/httpx[${PYTHON_USEDEP}]
		dev-python/pytest-asyncio[${PYTHON_USEDEP}]
		dev-python/pytest-mock[${PYTHON_USEDEP}]
		dev-python/pyyaml[${PYTHON_USEDEP}]
		dev-python/trustme[${PYTHON_USEDEP}]
		dev-python/websockets[${PYTHON_USEDEP}]
		dev-python/wsproto[${PYTHON_USEDEP}]
	)
"

PATCHES=(
	"${FILESDIR}/${P}-fix-wsproto-1.0.patch"
)

distutils_enable_tests pytest

python_prepare_all() {
	# watchgod is not in the tree
	sed -e '/^from uvicorn.supervisors.watchgodreload/d' \
		-e 's/, WatchGodReload//' \
		-i tests/supervisors/test_reload.py
	distutils-r1_python_prepare_all
}
