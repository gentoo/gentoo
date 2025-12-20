# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=flit
PYTHON_COMPAT=( python3_{11..14} pypy3_11 )
PYTHON_REQ_USE='threads(+),ssl(+)'

inherit distutils-r1 pypi

DESCRIPTION="Stand-alone Manifest generation & verification tool"
HOMEPAGE="
	https://github.com/gentoo/gemato/
	https://pypi.org/project/gemato/
"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86"
IUSE="+gpg pretty-log tools"

RDEPEND="
	gpg? (
		app-alternatives/gpg[ssl]
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

EPYTEST_PLUGINS=()
EPYTEST_XDIST=1
distutils_enable_tests pytest

python_install_all() {
	distutils-r1_python_install_all

	if use tools; then
		exeinto /usr/share/gemato
		doexe utils/*.{bash,py}
	fi
}
