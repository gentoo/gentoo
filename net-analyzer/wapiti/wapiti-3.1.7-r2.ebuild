# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..12} )
PYTHON_REQ_USE='xml(+)'

inherit distutils-r1

DESCRIPTION="Web-application vulnerability scanner"
HOMEPAGE="https://wapiti-scanner.github.io/"
SRC_URI="
	https://github.com/wapiti-scanner/wapiti/archive/refs/tags/${PV}.tar.gz -> ${P}.gh.tar.gz
"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
# Requires httpx-ntlm (to package)
#IUSE="ntlm"
IUSE="test"
PROPERTIES="test_network"
RESTRICT="test"

# httpx requires brotli and socks, so depending on
# dev-python/socksio and dev-python/brotlicffi
RDEPEND="
	>=dev-python/aiocache-0.12.0[${PYTHON_USEDEP}]
	>=dev-python/aiohttp-3.8.4[${PYTHON_USEDEP}]
	>=dev-python/aiosqlite-0.17.0[${PYTHON_USEDEP}]
	>=dev-python/arsenic-21.8[${PYTHON_USEDEP}]
	>=dev-python/beautifulsoup4-4.10.0[${PYTHON_USEDEP}]
	dev-python/brotlicffi[${PYTHON_USEDEP}]
	>=dev-python/browser-cookie3-0.16.2[${PYTHON_USEDEP}]
	>=dev-python/dnspython-2.1.0[${PYTHON_USEDEP}]
	>=dev-python/h11-0.14[${PYTHON_USEDEP}]
	>=dev-python/httpx-0.23.3[${PYTHON_USEDEP}]
	>=dev-python/loguru-0.5.3[${PYTHON_USEDEP}]
	>=dev-python/mako-1.1.4[${PYTHON_USEDEP}]
	>=dev-python/markupsafe-2.1.1[${PYTHON_USEDEP}]
	>=dev-python/pyasn1-0.4.8[${PYTHON_USEDEP}]
	>=dev-python/requests-1.2.3[${PYTHON_USEDEP}]
	dev-python/socksio[${PYTHON_USEDEP}]
	>=dev-python/sqlalchemy-1.4.26[${PYTHON_USEDEP}]
	>=dev-python/tld-0.12.5[${PYTHON_USEDEP}]
	>=dev-python/typing-extensions-4.4.0[${PYTHON_USEDEP}]
	>=dev-python/yaswfp-0.9.3[${PYTHON_USEDEP}]
	>=net-proxy/mitmproxy-9.0.0[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-lang/php
		dev-python/greenlet[${PYTHON_USEDEP}]
		dev-python/humanize[${PYTHON_USEDEP}]
		dev-python/responses[${PYTHON_USEDEP}]
		dev-python/respx[${PYTHON_USEDEP}]
	)
"

EPYTEST_PLUGINS=( pytest-asyncio )
distutils_enable_tests pytest

PATCHES=(
	"${FILESDIR}"/${PN}-3.1.6-setup_scripts.patch
	# part of https://github.com/wapiti-scanner/wapiti/commit/77fe140f8ad4d2fb266f1b49285479f6af25d6b7
	"${FILESDIR}"/${P}-httpx.patch
)

python_prepare_all() {
	sed -i 's/--cov --cov-report=xml//' setup.cfg || die
	sed -e 's/"pytest-runner"//' \
		-e "/DOC_DIR =/s/wapiti/${PF}/" \
		-i setup.py || die
	distutils-r1_python_prepare_all
}

EPYTEST_IGNORE=(
	# requires humanize, unpackaged sslyze
	tests/attack/test_mod_ssl.py
)
