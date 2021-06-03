# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..10} pypy3 )
PYTHON_REQ_USE='threads(+)'

inherit distutils-r1

DESCRIPTION="Stand-alone Manifest generation & verification tool"
HOMEPAGE="https://github.com/mgorny/gemato"
SRC_URI="mirror://pypi/${PN::1}/${PN}/${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~x64-cygwin ~amd64-linux ~x86-linux"
IUSE="+gpg tools"

RDEPEND="
	gpg? (
		>=app-crypt/gnupg-2.2.20-r1
		dev-python/requests[${PYTHON_USEDEP}]
	)"
BDEPEND="
	test? (
		>=app-crypt/gnupg-2.2.20-r1
		>=dev-python/pytest-5[${PYTHON_USEDEP}]
		dev-python/requests[${PYTHON_USEDEP}]
		dev-python/responses[${PYTHON_USEDEP}]
	)"

distutils_enable_tests pytest

python_install_all() {
	distutils-r1_python_install_all

	if use tools; then
		exeinto /usr/share/gemato
		doexe utils/*.{bash,py}
	fi
}
