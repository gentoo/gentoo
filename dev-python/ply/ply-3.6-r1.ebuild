# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python{2_7,3_3,3_4} pypy )

inherit distutils-r1

DESCRIPTION="Python Lex-Yacc library"
HOMEPAGE="http://www.dabeaz.com/ply/ https://pypi.python.org/pypi/ply"
SRC_URI="http://www.dabeaz.com/ply/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="alpha amd64 arm ~arm64 hppa ia64 ~m68k ~mips ppc ppc64 ~s390 ~sh ~sparc x86 ~x86-fbsd ~x86-freebsd ~x86-interix ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x64-solaris"
IUSE="examples"

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND=""

# See bug #458648 for reference
RESTRICT="test"

DOCS=( ANNOUNCE CHANGES TODO )
PATCHES=(
	"${FILESDIR}/3.6-lextab-None.patch"
	"${FILESDIR}/3.6-picklefile-IOError.patch"
)

python_test() {
	cp -r -l test "${BUILD_DIR}"/ || die
	cd "${BUILD_DIR}"/test || die

	local t
	for t in testlex.py testyacc.py; do
		"${PYTHON}" "${t}" || die "${t} fails with ${EPYTHON}"
	done
}

python_install_all() {
	local HTML_DOCS=( doc/. )
	use examples && local EXAMPLES=( example/. )
	distutils-r1_python_install_all
}
