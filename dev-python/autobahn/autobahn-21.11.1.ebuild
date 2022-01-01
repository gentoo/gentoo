# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )
DISTUTILS_USE_SETUPTOOLS=rdepend
inherit distutils-r1 optfeature

MY_P=${PN}-$(ver_rs 3 -)

DESCRIPTION="WebSocket and WAMP for Twisted and Asyncio"
HOMEPAGE="https://pypi.org/project/autobahn/
	https://crossbar.io/autobahn/
	https://github.com/crossbario/autobahn-python"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

SLOT="0"
LICENSE="MIT"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"
IUSE="test xbr"
RESTRICT="!test? ( test )"

# The order of deps is based on their appearance in setup.py
# All extra deps should be included in test and in optfeature
RDEPEND="
	>=dev-python/zope-interface-5.2.0[${PYTHON_USEDEP}]
	>=dev-python/twisted-20.3.0[${PYTHON_USEDEP}]
	>=dev-python/attrs-20.3.0[${PYTHON_USEDEP}]
	>=dev-python/txaio-21.2.1[${PYTHON_USEDEP}]
	dev-python/cryptography[${PYTHON_USEDEP}]
	>=dev-python/hyperlink-21.0.0[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		>=dev-python/wsaccel-0.6.3[${PYTHON_USEDEP}]
		>=dev-python/snappy-0.6.0[${PYTHON_USEDEP}]
		>=dev-python/msgpack-1.0.2[${PYTHON_USEDEP}]
		>=dev-python/ujson-4.0.2[${PYTHON_USEDEP}]
		>=dev-python/cbor2-5.2.0[${PYTHON_USEDEP}]
		>=dev-python/cbor-1.0.0[${PYTHON_USEDEP}]
		>=dev-python/py-ubjson-0.16.1[${PYTHON_USEDEP}]
		>=dev-python/flatbuffers-1.12[${PYTHON_USEDEP}]
		>=dev-python/pyopenssl-20.0.1[${PYTHON_USEDEP}]
		>=dev-python/service_identity-18.1.0[${PYTHON_USEDEP}]
		>=dev-python/pynacl-1.4.0[${PYTHON_USEDEP}]
		>=dev-python/pytrie-0.4[${PYTHON_USEDEP}]
		>=dev-python/pyqrcode-1.2.1[${PYTHON_USEDEP}]
		>=dev-python/cffi-1.14.5[${PYTHON_USEDEP}]
		>=dev-python/argon2-cffi-20.1.0[${PYTHON_USEDEP}]
		>=dev-python/passlib-1.7.4[${PYTHON_USEDEP}]

		dev-python/pytest[${PYTHON_USEDEP}]
		dev-python/pytest-asyncio[${PYTHON_USEDEP}]
		dev-python/pytest-aiohttp[${PYTHON_USEDEP}]
	)
"

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

	# avoid useless rust dependency
	sed -i -e '/cryptography/s:>=3.4.6::' setup.py || die

	# remove twisted plugin cache regen in setup.py
	# to fix tinderbox sandbox issue
	sed -e 's/regenerate Twisted plugin cache/DO NOT & in Gentoo\nexit()/' \
		-i setup.py || die

	distutils-r1_python_prepare_all
}

python_test() {
	einfo "Testing all, cryptosign using twisted"
	local -x USE_TWISTED=true
	cd "${BUILD_DIR}"/lib || die
	"${EPYTHON}" -m twisted.trial autobahn || die "Tests failed with ${EPYTHON}"
	unset USE_TWISTED

	einfo "RE-testing cryptosign and component_aio using asyncio"
	local -x USE_ASYNCIO=true
	epytest autobahn/wamp/test/test_wamp_{cryptosign,component_aio}.py
	unset USE_ASYNCIO

	rm -f "${BUILD_DIR}"/lib/twisted/plugins/dropin.cache || die
}

pkg_postinst() {
	optfeature "C-based WebSocket acceleration" "dev-python/wsaccel"
	optfeature "non-standard WebSocket compression support" "dev-python/snappy"
	optfeature "accelerated WAMP serialization support" \
		"dev-python/msgpack dev-python/ujson dev-python/cbor2 dev-python/cbor dev-python/flatbuffers dev-python/py-ubjson"
	optfeature "TLS transport encryption" \
		"dev-python/pyopenssl dev-python/pynacl dev-python/pytrie dev-python/pyqrcode dev-python/service_identity"
	optfeature "WAMP-SCRAM authentication" \
		"dev-python/cffi dev-python/argon2-cffi dev-python/passlib"
	optfeature "native SIMD acceleration" "dev-python/cffi"

	python_foreach_impl twisted-regen-cache
}

pkg_postrm() {
	python_foreach_impl twisted-regen-cache
}
