# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=flit
PYTHON_COMPAT=( python3_{10..13} pypy3 )
PYTHON_REQ_USE='threads(+)'

inherit distutils-r1 pypi

DESCRIPTION="Stand-alone Manifest generation & verification tool"
HOMEPAGE="
	https://github.com/projg2/gemato/
	https://pypi.org/project/gemato/
"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux"
IUSE="+gpg pretty-log tools"

RDEPEND="
	gpg? (
		>=app-crypt/gnupg-2.2.20-r1
		dev-python/requests[${PYTHON_USEDEP}]
	)
	pretty-log? (
		dev-python/rich[${PYTHON_USEDEP}]
	)
"
BDEPEND="
	test? (
		>=app-crypt/gnupg-2.2.20-r1
		dev-python/requests[${PYTHON_USEDEP}]
		dev-python/responses[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

python_install_all() {
	distutils-r1_python_install_all

	if use tools; then
		exeinto /usr/share/gemato
		doexe utils/*.{bash,py}
	fi
}
