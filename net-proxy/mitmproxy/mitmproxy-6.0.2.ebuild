# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DISTUTILS_USE_SETUPTOOLS=rdepend
PYTHON_COMPAT=( python3_{8,9} )
PYTHON_REQ_USE="sqlite"
inherit distutils-r1

DESCRIPTION="An interactive, SSL-capable, man-in-the-middle HTTP proxy"
HOMEPAGE="https://mitmproxy.org/"
SRC_URI="https://github.com/mitmproxy/mitmproxy/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm64 ~x86"
IUSE="libressl test"

RDEPEND="
	>=app-arch/brotli-1.0.0[python,${PYTHON_USEDEP}]
	>=dev-python/asgiref-3.2.10[${PYTHON_USEDEP}]
	>=dev-python/blinker-1.4[${PYTHON_USEDEP}]
	>=dev-python/certifi-2015.11.20.1[${PYTHON_USEDEP}]
	>=dev-python/click-7.0[${PYTHON_USEDEP}]
	>=dev-python/cryptography-3.3[${PYTHON_USEDEP}]
	>=dev-python/flask-1.1.1[${PYTHON_USEDEP}]
	>=dev-python/hyper-h2-4.0.0[${PYTHON_USEDEP}]
	>=dev-python/hyperframe-6.0.0[${PYTHON_USEDEP}]
	>=dev-python/kaitaistruct-0.7[${PYTHON_USEDEP}]
	>=dev-python/ldap3-2.8[${PYTHON_USEDEP}]
	>=dev-python/msgpack-1.0.0[${PYTHON_USEDEP}]
	>=dev-python/passlib-1.6.5[${PYTHON_USEDEP}]
	>=dev-python/protobuf-python-3.14.0[${PYTHON_USEDEP}]
	>=dev-python/publicsuffix-2.20190205[${PYTHON_USEDEP}]
	>=dev-python/pyasn1-0.3.1[${PYTHON_USEDEP}]
	>=dev-python/pyopenssl-20.0[${PYTHON_USEDEP}]
	>=dev-python/pyparsing-2.4.2[${PYTHON_USEDEP}]
	>=dev-python/pyperclip-1.6.0[${PYTHON_USEDEP}]
	>=dev-python/ruamel-yaml-0.16[${PYTHON_USEDEP}]
	>=dev-python/sortedcontainers-2.3.0[${PYTHON_USEDEP}]
	>=www-servers/tornado-4.3[${PYTHON_USEDEP}]
	>=dev-python/urwid-2.1.1[${PYTHON_USEDEP}]
	>=dev-python/wsproto-1.0.0[${PYTHON_USEDEP}]
	>=dev-python/zstandard-0.11.0[${PYTHON_USEDEP}]
	!libressl? ( dev-libs/openssl:0 )
	libressl? ( >=dev-libs/libressl-3.2.0:0 )
"

DEPEND="${RDEPEND}
	test? (
		>=dev-python/hypothesis-4.50.8[${PYTHON_USEDEP}]
		>=dev-python/parver-0.1[${PYTHON_USEDEP}]
		>=dev-python/pytest-3.3[${PYTHON_USEDEP}]
		>=dev-python/pytest-asyncio-0.10.0[${PYTHON_USEDEP}]
		>=dev-python/requests-2.9.1[${PYTHON_USEDEP}]
		>=dev-python/zstandard-0.8.1[${PYTHON_USEDEP}]
	)"

RESTRICT="!test? ( test )"

distutils_enable_tests pytest

python_prepare_all() {
	# loosen dependencies
	sed -i \
		-e '/>/s/>.*/",/g' \
		-e '/python_requires/d' \
		setup.py || die

	# remove failing test
	sed -i 's/test_get_version/_&/g' test/mitmproxy/test_version.py || die

	# https://github.com/mitmproxy/mitmproxy/issues/4136
	# https://bugs.gentoo.org/740336
	rm test/mitmproxy/addons/test_termlog.py || die

	# requires asynctest
	rm test/mitmproxy/addons/test_readfile.py || die

	# Passes with OpenSSL 1.1.1g, fails with OpenSSL 1.1.1h
	# https://github.com/gentoo/gentoo/pull/17411#discussion_r497270699
	sed \
		-e 's/test_mode_none_should_pass_without_sni/_&/g' \
		-e 's/test_mode_strict_w_pemfile_should_pass/_&/g' \
		-e 's/test_mode_strict_w_confdir_should_pass/_&/g' \
		-i test/mitmproxy/net/test_tcp.py || die
	sed \
		-e 's/test_verification_w_confdir/_&/g' \
		-e 's/test_verification_w_pemfile/_&/g' \
		-i test/mitmproxy/proxy/test_server.py || die

	distutils-r1_python_prepare_all
}
