# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Alternative Python bindings for Subversion"
HOMEPAGE="https://www.samba.org/~jelmer/subvertpy/ https://pypi.org/project/subvertpy/"
SRC_URI="https://www.samba.org/~jelmer/${PN}/${P}.tar.gz"

LICENSE="|| ( LGPL-2.1 LGPL-3 )"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND=">=dev-vcs/subversion-1.4"
DEPEND="${RDEPEND}
	test? ( || (
		dev-python/testtools
	) )"

DOCS=( NEWS AUTHORS )
S=${WORKDIR}

python_compile() {
	python_is_python3 || local -x CFLAGS="${CFLAGS} -fno-strict-aliasing"
	distutils-r1_python_compile
}

python_test() {
	distutils_install_for_testing
	pushd man > /dev/null
	# hack: the subvertpy in . has no compiled modules, so cd into any
	# directory to give the installed version precedence on PYTHONPATH
	${PYTHON} -m unittest subvertpy.tests.test_suite
	popd man > /dev/null
}
