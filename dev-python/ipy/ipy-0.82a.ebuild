# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

PYTHON_COMPAT=( python2_7 python3_{3,4} pypy )

inherit distutils-r1

MY_PN="IPy"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Class and tools for handling of IPv4 and IPv6 addresses and networks"
HOMEPAGE="https://github.com/haypo/python-ipy/wiki http://pypi.python.org/pypi/IPy"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~ppc ~ppc64 ~sparc x86"
IUSE="examples"

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND=""

S="${WORKDIR}/python-${PN}-${MY_P}"

python_test() {
	# doctests for py3 unaltered read py2 files from "${S}" causing total failure
	# https://github.com/haypo/python-ipy/issues/17
	cp -r test_doc.py README test "${BUILD_DIR}" || die
	pushd "${BUILD_DIR}" > /dev/null || die
	"${PYTHON}" test/test_IPy.py || die "Tests fail with ${EPYTHON}"
	"${PYTHON}" test_doc.py || die "Doctests fail with ${EPYTHON}"
	popd > /dev/null || die
}

python_install_all() {
	use examples && local EXAMPLES=( example/. )
	distutils-r1_python_install_all
}
