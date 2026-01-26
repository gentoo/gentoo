# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..14} pypy3_11 )

inherit distutils-r1 pypi

DESCRIPTION="Python Serial Port extension"
HOMEPAGE="
	https://github.com/pyserial/pyserial/
	https://pypi.org/project/pyserial/
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~arm64-macos ~x64-macos"
IUSE="examples"

DOCS=( CHANGES.rst README.rst )

PATCHES=(
	"${FILESDIR}/${P}-unittest-fix.patch"
	"${FILESDIR}/${P}-glibc-2.42.patch"
)

distutils_enable_sphinx documentation --no-autodoc

python_test() {
	"${EPYTHON}" test/run_all_tests.py loop:// -v ||
		die "Testing failed with ${EPYTHON}"
}

python_install_all() {
	distutils-r1_python_install_all
	if use examples; then
		dodoc -r examples
		docompress -x /usr/share/doc/${PF}/examples
	fi
}
