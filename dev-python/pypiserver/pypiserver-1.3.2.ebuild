# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DISTUTILS_USE_SETUPTOOLS=rdepend
PYTHON_COMPAT=( python{2_7,3_{6,7,8,9}} pypy3 )
inherit distutils-r1

DESCRIPTION="Minimal PyPI server"
HOMEPAGE="https://github.com/pypiserver/pypiserver"
SRC_URI="https://github.com/${PN}/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="ZLIB MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm64 ~hppa ~sparc ~x86"
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
		$(python_gen_cond_dep 'dev-python/mock[${PYTHON_USEDEP}]' -2)
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
