# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..10} pypy3 )
inherit distutils-r1

DESCRIPTION="Minimal PyPI server"
HOMEPAGE="https://github.com/pypiserver/pypiserver"
SRC_URI="https://github.com/${PN}/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="ZLIB MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ppc ppc64 ~riscv sparc x86 ~x64-macos"
IUSE="test"

RDEPEND="
	dev-python/pip[${PYTHON_USEDEP}]
	>=dev-python/wheel-0.25.0[${PYTHON_USEDEP}]"
BDEPEND="
	dev-python/setuptools-git[${PYTHON_USEDEP}]
	test? (
		${RDEPEND}
		dev-python/passlib[${PYTHON_USEDEP}]
		>=dev-python/pytest-2.3[${PYTHON_USEDEP}]
		dev-python/twine[${PYTHON_USEDEP}]
		dev-python/webtest[${PYTHON_USEDEP}]
	)"

DOCS=( README.rst )

distutils_enable_tests pytest

src_prepare() {
	sed -i -e "/tox/d" setup.py || die

	# https://github.com/pypiserver/pypiserver/issues/312
	sed -e 's:test_root_count:_&:' \
		-i tests/test_app.py || die
	sed -e 's:test_hash_algos:_&:' \
		-e 's:test_pipInstall_openOk:_&:' \
		-e 's:test_pipInstall_authedOk:_&:' \
		-i tests/test_server.py || die

	distutils-r1_src_prepare
}
