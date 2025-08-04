# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..14} python3_{13,14}t pypy3_11 )

inherit distutils-r1 pypi

DESCRIPTION="Python Lex-Yacc library"
HOMEPAGE="
	http://www.dabeaz.com/ply/
	https://github.com/dabeaz/ply/
	https://pypi.org/project/ply/
"
SRC_URI+=" https://dev.gentoo.org/~sam/distfiles/${CATEGORY}/${PN}/${P}-py3.12-assert.patch.xz"

LICENSE="BSD"
SLOT="0/${PV}"
KEYWORDS="~alpha amd64 arm arm64 hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~arm64-macos ~ppc-macos ~x64-macos ~x64-solaris"
IUSE="examples"

DOCS=( ANNOUNCE CHANGES TODO )

PATCHES=(
	"${FILESDIR}/3.6-picklefile-IOError.patch"
	"${WORKDIR}/${P}-py3.12-assert.patch"
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
