# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )
inherit distutils-r1

DESCRIPTION="A supersonic micro-framework for building cloud APIs"
HOMEPAGE="https://falconframework.org/ https://pypi.org/project/falcon/"
SRC_URI="https://github.com/falconry/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

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
	)"

distutils_enable_tests pytest

src_prepare() {
	# do not install 'examples'
	sed -i -e "s:'tests':'examples', &:" setup.py || die
	distutils-r1_src_prepare
}

python_test() {
	local deselect=(
		# mujson is unpackaged, test-only dep
		--ignore tests/test_media_handlers.py
	)

	cp -r tests "${BUILD_DIR}" || die
	cd "${BUILD_DIR}" || die
	epytest tests "${deselect[@]}"
}
