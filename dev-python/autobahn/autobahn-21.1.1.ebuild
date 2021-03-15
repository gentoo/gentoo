# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )
DISTUTILS_USE_SETUPTOOLS=rdepend

inherit distutils-r1

MY_P=${PN}-$(ver_rs 3 -)

DESCRIPTION="WebSocket and WAMP for Twisted and Asyncio"
HOMEPAGE="https://pypi.org/project/autobahn/
	https://crossbar.io/autobahn/
	https://github.com/crossbario/autobahn-python"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${MY_P}.tar.gz"
S=${WORKDIR}/${MY_P}

SLOT="0"
LICENSE="MIT"
KEYWORDS="amd64 ~arm ~arm64 ~x86"
IUSE="crypt scram test xbr"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-python/attrs-19.2.0[${PYTHON_USEDEP}]
	>=dev-python/cbor-1.0.0[${PYTHON_USEDEP}]
	>=dev-python/cbor2-5.1.0[${PYTHON_USEDEP}]
	>=dev-python/cryptography-2.9.2[${PYTHON_USEDEP}]
	>=dev-python/flatbuffers-1.10.0[${PYTHON_USEDEP}]
	>=dev-python/jinja-2.11.2[${PYTHON_USEDEP}]
	>=dev-python/lz4-0.7.0[${PYTHON_USEDEP}]
	>=dev-python/msgpack-0.6.1[${PYTHON_USEDEP}]
	>=dev-python/py-ubjson-0.8.4[${PYTHON_USEDEP}]
	>=dev-python/snappy-0.5[${PYTHON_USEDEP}]
	>=dev-python/twisted-20.3.0[${PYTHON_USEDEP}]
	>=dev-python/txaio-20.4.1[${PYTHON_USEDEP}]
	>=dev-python/ujson-2.0.0[${PYTHON_USEDEP}]
	>=dev-python/wsaccel-0.6.2[${PYTHON_USEDEP}]
	>=dev-python/zope-interface-3.6[${PYTHON_USEDEP}]
	crypt? (
		>=dev-python/pyopenssl-16.2.0[${PYTHON_USEDEP}]
		>=dev-python/pynacl-1.0.1[${PYTHON_USEDEP}]
		>=dev-python/pytrie-0.2[${PYTHON_USEDEP}]
		>=dev-python/pyqrcode-1.1.0[${PYTHON_USEDEP}]
		>=dev-python/service_identity-18.1.0[${PYTHON_USEDEP}]
	)
	scram? (
		dev-python/cffi[${PYTHON_USEDEP}]
		dev-python/argon2-cffi[${PYTHON_USEDEP}]
		dev-python/passlib[${PYTHON_USEDEP}]
	)
	"
BDEPEND="
	test? (
		dev-python/mock[${PYTHON_USEDEP}]
		dev-python/pytest[${PYTHON_USEDEP}]
		dev-python/pytest-asyncio[${PYTHON_USEDEP}]
		>=dev-python/pynacl-1.0.1[${PYTHON_USEDEP}]
		>=dev-python/pytrie-0.2[${PYTHON_USEDEP}]
		>=dev-python/pyqrcode-1.1.0[${PYTHON_USEDEP}]
	)"

python_prepare_all() {
	if use xbr ; then
		eerror "***************"
		eerror "Required xbr dependencies are incomplete in Gentoo."
		eerror "So this functionality will not yet work"
		eerror "Please file a bug if this feature is needed"
		eerror "***************"
	else
		# remove xbr components
		export AUTOBAHN_STRIP_XBR="True"
	fi
	distutils-r1_python_prepare_all
}

python_test() {
	einfo "Testing all, cryptosign using twisted"
	local -x USE_TWISTED=true
	cd "${BUILD_DIR}"/lib || die
	"${EPYTHON}" -m twisted.trial autobahn || die
	unset USE_TWISTED
	einfo "RE-testing cryptosign and component_aio using asyncio"
	local -x USE_ASYNCIO=true
	pytest -vv autobahn/wamp/test/test_wamp_cryptosign.py || die
	pytest -vv autobahn/wamp/test/test_wamp_component_aio.py || die
	unset USE_ASYNCIO
	rm -r .pytest_cache || die
}

python_install_all() {
	distutils-r1_python_install_all

	# delete the dropin.cache so we don't have collisions if it exists
	rm "${D}"/usr/lib*/python*/site-packages/twisted/plugins//dropin.cache > /dev/null
}

pkg_postinst() {
	python_foreach_impl twisted-regen-cache || die
}

pkg_postrm() {
	python_foreach_impl twisted-regen-cache || die
}
