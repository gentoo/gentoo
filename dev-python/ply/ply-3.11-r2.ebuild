# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# please keep this ebuild at EAPI 7 -- sys-apps/portage dep
EAPI=7

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} pypy3 )

inherit distutils-r1 pypi

DESCRIPTION="Python Lex-Yacc library"
HOMEPAGE="
	http://www.dabeaz.com/ply/
	https://github.com/dabeaz/ply/
	https://pypi.org/project/ply/
"

LICENSE="BSD"
SLOT="0/${PV}"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~x64-cygwin ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="examples"

DOCS=( ANNOUNCE CHANGES TODO )

PATCHES=(
	"${FILESDIR}/3.6-picklefile-IOError.patch"
)

python_test() {
	# Checks for pyc/pyo files
	local -x PYTHONDONTWRITEBYTECODE=

	cd test || die
	local t
	for t in testlex.py testyacc.py; do
		"${EPYTHON}" "${t}" -v || die "${t} fails with ${EPYTHON}"
	done
}

python_install_all() {
	local HTML_DOCS=( doc/. )
	use examples && dodoc -r example
	distutils-r1_python_install_all
}
