# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Object-oriented framework for creating a code generator for Boost.Python library"
HOMEPAGE="http://www.language-binding.net/"

if [[ ${PV} == 9999 ]]; then
	ESVN_REPO_URI="http://svn.code.sf.net/p/pygccxml/svn/${PN}_dev"
	inherit subversion
	S=${WORKDIR}/${PN}_dev
else
	SRC_URI="http://dev.gentoo.org/~heroxbd/${P}.tar.xz"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="freedist Boost-1.0"
SLOT="0"
IUSE="examples numpy"

DEPEND="app-arch/unzip
	numpy? ( dev-python/numpy[${PYTHON_USEDEP}] )"
RDEPEND="dev-python/pygccxml[${PYTHON_USEDEP}]"

python_test() {
	"${PYTHON}" unittests/test_all.py || die "Tests fail with ${EPYTHON}"
}

python_install_all() {
	use examples && local EXAMPLES=( examples/. )

	distutils-r1_python_install_all
}
