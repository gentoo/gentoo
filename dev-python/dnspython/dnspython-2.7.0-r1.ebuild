# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( python3_{11..14} pypy3_11 )

inherit distutils-r1

DESCRIPTION="DNS toolkit for Python"
HOMEPAGE="
	https://www.dnspython.org/
	https://github.com/rthalley/dnspython/
	https://pypi.org/project/dnspython/
"
SRC_URI="
	https://github.com/rthalley/dnspython/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="ISC"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~m68k ~riscv ~x86"
IUSE="dnssec examples https quic"

RDEPEND="
	dnssec? (
		>=dev-python/cryptography-41[${PYTHON_USEDEP}]
	)
	>=dev-python/idna-2.1[${PYTHON_USEDEP}]
	https? (
		>=dev-python/httpx-0.26.0[${PYTHON_USEDEP}]
		>=dev-python/h2-4.1.0[${PYTHON_USEDEP}]
	)
	quic? ( >=dev-python/aioquic-0.9.25[${PYTHON_USEDEP}] )
"
# note: skipping DoH test deps because they require Internet anyway
BDEPEND="
	test? (
		>=dev-python/cryptography-41[${PYTHON_USEDEP}]
		>=dev-python/quart-trio-0.11.0[${PYTHON_USEDEP}]
	)
"

EPYTEST_PLUGINS=()
distutils_enable_tests pytest

python_test() {
	local -x NO_INTERNET=1
	epytest
}

python_install_all() {
	distutils-r1_python_install_all
	if use examples; then
		dodoc -r examples
		docompress -x /usr/share/doc/${PF}/examples
	fi
}
