# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..13} pypy3 )

inherit distutils-r1 pypi

DESCRIPTION="pyasn1 modules"
HOMEPAGE="
	https://pypi.org/project/pyasn1-modules/
	https://github.com/pyasn1/pyasn1-modules/
"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~x64-macos"

RDEPEND="
	<dev-python/pyasn1-0.7.0[${PYTHON_USEDEP}]
	>=dev-python/pyasn1-0.4.6[${PYTHON_USEDEP}]
"

distutils_enable_tests unittest

PATCHES=(
	# https://github.com/pyasn1/pyasn1-modules/pull/22
	"${FILESDIR}/${P}-test.patch"
)

python_install_all() {
	distutils-r1_python_install_all
	insinto /usr/share/${P}
	doins -r tools
}
