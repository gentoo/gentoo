# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1 optfeature pypi

DESCRIPTION="WebSocket and WAMP for Twisted and Asyncio"
HOMEPAGE="
	https://github.com/crossbario/autobahn-python/
	https://pypi.org/project/autobahn/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ~riscv ~sparc ~x86"
IUSE="test xbr"
RESTRICT="!test? ( test )"

# The order of deps is based on their appearance in setup.py
# All extra deps should be included in test and in optfeature
RDEPEND="
	>=dev-python/zope-interface-5.2.0[${PYTHON_USEDEP}]
	>=dev-python/twisted-24.3.0[${PYTHON_USEDEP}]
	>=dev-python/attrs-20.3.0[${PYTHON_USEDEP}]
	>=dev-python/txaio-21.2.1[${PYTHON_USEDEP}]
	dev-python/cryptography[${PYTHON_USEDEP}]
	>=dev-python/hyperlink-21.0.0[${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		${RDEPEND}
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
		>=dev-python/pytrie-0.4[${PYTHON_USEDEP}]
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

	distutils-r1_python_prepare_all

	# avoid useless rust dependency
	sed -i -e '/cryptography/s:>=3.4.6::' setup.py || die

	# remove twisted plugin cache regen in setup.py
	# to fix tinderbox sandbox issue
	sed -e '/import/s:reactor:__importmustfail__:' \
		-i setup.py || die

	# https://github.com/crossbario/autobahn-python/issues/1646
	sed -e 's:(forbid_global_loop=True)::' \
		-i autobahn/wamp/test/test_wamp_component_aio.py || die
}

python_test() {
	rm -rf autobahn || die

	einfo "Testing all, cryptosign using twisted"
	local -x USE_TWISTED=true
	"${EPYTHON}" -m twisted.trial autobahn || die "Tests failed with ${EPYTHON}"
	unset USE_TWISTED

	einfo "RE-testing cryptosign and component_aio using asyncio"
	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	local -x USE_ASYNCIO=true
	epytest -p asyncio --pyargs \
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
