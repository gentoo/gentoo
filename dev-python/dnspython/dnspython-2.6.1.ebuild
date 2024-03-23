# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( python3_{10..12} pypy3 )

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
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos"
IUSE="dnssec examples"

RDEPEND="
	dnssec? (
		>=dev-python/cryptography-41[${PYTHON_USEDEP}]
	)
	>=dev-python/idna-2.1[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		>=dev-python/cryptography-41[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

python_install_all() {
	distutils-r1_python_install_all
	if use examples; then
		dodoc -r examples
		docompress -x /usr/share/doc/${PF}/examples
	fi
}
