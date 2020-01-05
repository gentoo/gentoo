# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python2_7 python3_6 )

inherit distutils-r1 versionator

MY_P="${PN}-$(replace_version_separator 3 -)"

DESCRIPTION="WebSocket and WAMP for Twisted and Asyncio"
HOMEPAGE="https://pypi.org/project/autobahn/
	https://crossbar.io/autobahn/
	https://github.com/crossbario/autobahn-python"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${MY_P}.tar.gz"

SLOT="0"
LICENSE="MIT"
KEYWORDS="amd64 x86"
IUSE="crypt test"
RESTRICT="!test? ( test )"

RDEPEND="
	$(python_gen_cond_dep '>=dev-python/trollius-2.0[${PYTHON_USEDEP}]' 'python2_7')
	$(python_gen_cond_dep '>=dev-python/futures-3.0.4[${PYTHON_USEDEP}]' 'python2_7')
	>=dev-python/cbor-1.0.0[${PYTHON_USEDEP}]
	>=dev-python/lz4-0.7.0[${PYTHON_USEDEP}]
	crypt? (
		>=dev-python/pyopenssl-16.2.0[${PYTHON_USEDEP}]
		>=dev-python/pynacl-1.0.1[${PYTHON_USEDEP}]
		>=dev-python/pytrie-0.2[${PYTHON_USEDEP}]
		>=dev-python/pyqrcode-1.1.0[${PYTHON_USEDEP}]
		>=dev-python/service_identity-16.0.0
	)
	>=dev-python/six-1.10.0[${PYTHON_USEDEP}]
	>=dev-python/snappy-0.5[${PYTHON_USEDEP}]
	>=dev-python/twisted-16.6.0-r2[${PYTHON_USEDEP}]
	>=dev-python/txaio-2.6.1[${PYTHON_USEDEP}]
	>=dev-python/u-msgpack-2.1[${PYTHON_USEDEP}]
	>=dev-python/py-ubjson-0.8.4[${PYTHON_USEDEP}]
	>=dev-python/wsaccel-0.6.2[${PYTHON_USEDEP}]
	>=dev-python/zope-interface-3.6[${PYTHON_USEDEP}]
	"
DEPEND="${RDEPEND}
	test? (
		dev-python/mock[${PYTHON_USEDEP}]
		dev-python/pytest[${PYTHON_USEDEP}]
		>=dev-python/pynacl-1.0.1[${PYTHON_USEDEP}]
		>=dev-python/pytrie-0.2[${PYTHON_USEDEP}]
		>=dev-python/pyqrcode-1.1.0[${PYTHON_USEDEP}]
	)"

S="${WORKDIR}"/${MY_P}

python_test() {
	#esetup.py test
	cd "${BUILD_DIR}"/lib || die
	py.test -v || die
}

pkg_postinst() {
	python_foreach_impl twisted-regen-cache || die
}

pkg_postrm() {
	python_foreach_impl twisted-regen-cache || die
}
