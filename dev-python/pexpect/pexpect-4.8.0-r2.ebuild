# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..10} pypy3 )
PYTHON_REQ_USE="threads(+)"
DISTUTILS_USE_SETUPTOOLS=no

inherit distutils-r1

DESCRIPTION="Python module for spawning child apps and responding to expected patterns"
HOMEPAGE="https://pexpect.readthedocs.io/ https://pypi.org/project/pexpect/ https://github.com/pexpect/pexpect/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos"
IUSE="examples"

RDEPEND=">=dev-python/ptyprocess-0.5[${PYTHON_USEDEP}]"

PATCHES=(
	"${FILESDIR}"/${P}-sphinx-3.patch
	"${FILESDIR}"/${P}-fix-PS1.patch
)

distutils_enable_tests pytest
distutils_enable_sphinx doc

src_test() {
	# workaround new readline defaults
	echo "set enable-bracketed-paste off" > "${T}"/inputrc || die
	local -x INPUTRC="${T}"/inputrc
	distutils-r1_src_test
}

python_install_all() {
	if use examples; then
		dodoc -r examples
		docompress -x /usr/share/doc/${PF}/examples
	fi
	distutils-r1_python_install_all
}
