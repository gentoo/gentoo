# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..13} )
PYTHON_REQ_USE="sqlite"

inherit distutils-r1

DESCRIPTION="An interactive, SSL-capable, man-in-the-middle HTTP proxy"
HOMEPAGE="
	https://mitmproxy.org/
	https://github.com/mitmproxy/mitmproxy/
	https://pypi.org/project/mitmproxy/
"
SRC_URI="
	https://github.com/mitmproxy/mitmproxy/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm64"

RDEPEND="
	>=app-arch/brotli-1.0.0[python,${PYTHON_USEDEP}]
	>=dev-python/aioquic-1.1.0[${PYTHON_USEDEP}]
	>=dev-python/asgiref-3.2.10[${PYTHON_USEDEP}]
	>=dev-python/certifi-2019.9.11[${PYTHON_USEDEP}]
	>=dev-python/cryptography-42.0[${PYTHON_USEDEP}]
	>=dev-python/flask-3.0[${PYTHON_USEDEP}]
	>=dev-python/h2-4.1.0[${PYTHON_USEDEP}]
	>=dev-python/hyperframe-6.0.0[${PYTHON_USEDEP}]
	>=dev-python/kaitaistruct-0.10[${PYTHON_USEDEP}]
	>=dev-python/ldap3-2.8[${PYTHON_USEDEP}]
	>=net-proxy/mitmproxy-rs-0.10.7[${PYTHON_USEDEP}]
	>=dev-python/msgpack-1.0.0[${PYTHON_USEDEP}]
	>=dev-python/passlib-1.6.5[${PYTHON_USEDEP}]
	>=dev-python/publicsuffix2-2.20190812[${PYTHON_USEDEP}]
	>=dev-python/pyopenssl-22.1[${PYTHON_USEDEP}]
	>=dev-python/pyparsing-2.4.2[${PYTHON_USEDEP}]
	>=dev-python/pyperclip-1.9.0[${PYTHON_USEDEP}]
	>=dev-python/ruamel-yaml-0.16[${PYTHON_USEDEP}]
	>=dev-python/sortedcontainers-2.3.0[${PYTHON_USEDEP}]
	>=dev-python/tornado-6.4.1[${PYTHON_USEDEP}]
	$(python_gen_cond_dep '
		>=dev-python/typing-extensions-4.3[${PYTHON_USEDEP}]
	' 3.10)
	>=dev-python/urwid-2.6.14[${PYTHON_USEDEP}]
	>=dev-python/wsproto-1.0.0[${PYTHON_USEDEP}]
	>=dev-python/zstandard-0.15.0[${PYTHON_USEDEP}]
"

BDEPEND="
	test? (
		>=dev-python/click-7.0[${PYTHON_USEDEP}]
		>=dev-python/hypothesis-6.104.2[${PYTHON_USEDEP}]
		>=dev-python/pytest-asyncio-0.23.6[${PYTHON_USEDEP}]
		>=dev-python/requests-2.9.1[${PYTHON_USEDEP}]
	)
"

EPYTEST_XDIST=1
distutils_enable_tests pytest

python_prepare_all() {
	distutils-r1_python_prepare_all

	# unpin dependencies
	sed -i -r -e 's:,?<=?[0-9.]+,?::' pyproject.toml || die
}

python_test() {
	local EPYTEST_DESELECT=(
		# TODO
		test/mitmproxy/addons/test_termlog.py::test_cannot_print

		# requires root?
		test/mitmproxy/proxy/test_mode_servers.py::test_tun_mode
	)

	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	epytest -p asyncio
}
