# Copyright 2023-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=flit
PYTHON_COMPAT=( pypy3 python3_{10..13} )

inherit distutils-r1

DESCRIPTION="Verify certificates using native system trust stores"
HOMEPAGE="
	https://github.com/sethmlarson/truststore/
	https://pypi.org/project/truststore/
"
SRC_URI="
	https://github.com/sethmlarson/truststore/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~ppc64 ~riscv ~sparc ~x86"
# The vast majority of tests require Internet access.
PROPERTIES="test_network"
RESTRICT="test"


distutils_enable_tests pytest

python_test() {
	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	epytest -p asyncio -p pytest_httpserver
}
