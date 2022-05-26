# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=poetry
PYTHON_COMPAT=( python3_{8..11} pypy3 )

inherit distutils-r1

DESCRIPTION="DNS toolkit for Python"
HOMEPAGE="
	https://www.dnspython.org/
	https://github.com/rthalley/dnspython/
	https://pypi.org/project/dnspython/
"
SRC_URI="
	https://github.com/rthalley/dnspython/archive/v${PV}.tar.gz
		-> ${P}.tar.gz
"

LICENSE="ISC"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-solaris"
IUSE="examples"

RDEPEND="
	dev-python/cryptography[${PYTHON_USEDEP}]
	<dev-python/idna-4.0[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest

src_prepare() {
	sed -i -e '/network_avail/s:True:False:' \
		tests/*.py || die
	distutils-r1_src_prepare
}

python_test() {
	epytest -s
}

python_install_all() {
	distutils-r1_python_install_all
	if use examples; then
		dodoc -r examples
		docompress -x /usr/share/doc/${PF}/examples
	fi
}
