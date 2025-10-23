# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..13} )

inherit distutils-r1 optfeature pypi

DESCRIPTION="WebSocket and WAMP for Twisted and Asyncio"
HOMEPAGE="
	https://github.com/crossbario/autobahn-python/
	https://pypi.org/project/autobahn/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="+native-extensions test xbr"
RESTRICT="!test? ( test )"

# The order of deps is based on their appearance in pyproject.toml
# All extra deps should be included in test and in optfeature
RDEPEND="
	>=dev-python/txaio-25.9.2[${PYTHON_USEDEP}]
	>=dev-python/cryptography-3.4.6[${PYTHON_USEDEP}]
	>=dev-python/hyperlink-21.0.0[${PYTHON_USEDEP}]

	>=dev-python/zope-interface-5.2.0[${PYTHON_USEDEP}]
	>=dev-python/twisted-24.3.0[${PYTHON_USEDEP}]
	>=dev-python/attrs-20.3.0[${PYTHON_USEDEP}]

	native-extensions? (
		$(python_gen_cond_dep '
			>=dev-python/cffi-1.14.5[${PYTHON_USEDEP}]
		' 'python*')
	)
"
BDEPEND="
	native-extensions? (
		$(python_gen_cond_dep '
			>=dev-python/cffi-1.14.5[${PYTHON_USEDEP}]
		' 'python*')
	)

	test? (
		>=dev-python/wsaccel-0.6.3[${PYTHON_USEDEP}]
		>=dev-python/python-snappy-0.6.0[${PYTHON_USEDEP}]
		>=dev-python/msgpack-1.0.2[${PYTHON_USEDEP}]
		>=dev-python/ujson-4.0.2[${PYTHON_USEDEP}]
		>=dev-python/cbor2-5.2.0[${PYTHON_USEDEP}]
		>=dev-python/py-ubjson-0.16.1[${PYTHON_USEDEP}]
		>=dev-python/flatbuffers-22.12.06[${PYTHON_USEDEP}]
		>=dev-python/pyopenssl-20.0.1[${PYTHON_USEDEP}]
		>=dev-python/service-identity-18.1.0[${PYTHON_USEDEP}]
		>=dev-python/pynacl-1.4.0[${PYTHON_USEDEP}]
		>=dev-python/pytrie-0.4.0[${PYTHON_USEDEP}]
		>=dev-python/qrcode-7.3.1[${PYTHON_USEDEP}]
		>=dev-python/base58-2.1.1[${PYTHON_USEDEP}]
		>=dev-python/ecdsa-0.19.1[${PYTHON_USEDEP}]
		>=dev-python/argon2-cffi-20.1.0[${PYTHON_USEDEP}]
		>=dev-python/passlib-1.7.4[${PYTHON_USEDEP}]
	)
"

EPYTEST_PLUGINS=( pytest-{asyncio,aiohttp} )
distutils_enable_tests pytest

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

	if ! use native-extensions; then
		export AUTOBAHN_USE_NVX=0
	fi
}

python_test() {
	rm -rf autobahn || die

	einfo "Testing all, cryptosign using twisted"
	local -x USE_TWISTED=true
	"${EPYTHON}" -m twisted.trial autobahn || die "Tests failed with ${EPYTHON}"
	unset USE_TWISTED

	einfo "RE-testing cryptosign and component_aio using asyncio"
	local -x USE_ASYNCIO=true
	epytest --pyargs \
		autobahn.asyncio.test.test_aio_{raw,web}socket \
		autobahn.wamp.test.test_wamp_{cryptosign,component_aio}
	unset USE_ASYNCIO

	rm -f twisted/plugins/dropin.cache || die
}

pkg_postinst() {
	optfeature "C-based WebSocket acceleration" "dev-python/wsaccel"
	optfeature "non-standard WebSocket compression support" \
		"dev-python/python-snappy"
	optfeature "accelerated WAMP serialization support" \
		"dev-python/msgpack dev-python/ujson dev-python/cbor2 dev-python/flatbuffers dev-python/py-ubjson"
	optfeature "TLS transport encryption" \
		"dev-python/pyopenssl dev-python/pynacl dev-python/pytrie dev-python/qrcode dev-python/service-identity"
	optfeature "WAMP-SCRAM authentication" \
		"dev-python/cffi dev-python/argon2-cffi dev-python/passlib"
	optfeature "native SIMD acceleration" "dev-python/cffi"

	python_foreach_impl twisted-regen-cache
}

pkg_postrm() {
	python_foreach_impl twisted-regen-cache
}
