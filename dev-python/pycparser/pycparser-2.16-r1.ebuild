# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{4,5} pypy pypy3 )

inherit distutils-r1 vcs-snapshot

DESCRIPTION="C parser and AST generator written in Python"
HOMEPAGE="https://github.com/eliben/pycparser"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~x86-fbsd ~x86-freebsd ~x86-interix ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x64-solaris"
IUSE="test"

RDEPEND="dev-python/ply[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? ( dev-python/nose[${PYTHON_USEDEP}] )"

pkg_pretend() {
	if has_version "=dev-python/pycparser-2.16"; then
		eerror "You have a broken version of dev-python/pycparser installed."
		eerror "Please remove the broken version before continuing."
		eerror "eg. emerge --unmerge =dev-python/pycparser-2.16"
		die "Broken dev-python/pycparser"
	fi
}

python_prepare_all() {
	# Bad permissions in tarball
	chmod -R go+rX "${S}" || die
	distutils-r1_python_prepare_all
}

python_compile() {
	distutils-r1_python_compile
	pushd "${BUILD_DIR}/lib/pycparser" > /dev/null || die
	"${PYTHON}" _build_tables.py || die
	popd > /dev/null || die
}

python_test() {
	nosetests || die
}
