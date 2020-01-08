# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{6,7} )
PYTHON_REQ_USE="sqlite"

inherit distutils-r1 flag-o-matic virtualx

MYSLOT=2
MY_PN=${PN}${MYSLOT}
MY_P=${MY_PN}-${PV}

DESCRIPTION="Python interface to the R Programming Language"
HOMEPAGE="https://rpy.sourceforge.net/
	https://pypi.org/project/rpy2/"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz"

LICENSE="AGPL-3 GPL-2 LGPL-2.1 MPL-1.1"
SLOT="0"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"
IUSE="test"

# ggplot2 is a test dep but not in portage
RESTRICT="test"

RDEPEND="
	>=dev-lang/R-3.2
	dev-python/numpy[${PYTHON_USEDEP}]
	>=dev-python/pandas-0.13.1[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
	virtual/python-singledispatch[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}
	test? ( >=dev-lang/R-3.2[X,png] )
	dev-python/setuptools[${PYTHON_USEDEP}]"
PDEPEND="dev-python/ipython[${PYTHON_USEDEP}]"

S="${WORKDIR}/${MY_P}"

python_compile() {
	if ! python_is_python3; then
		local CFLAGS=${CFLAGS}
		append-cflags -fno-strict-aliasing
	fi
	distutils-r1_python_compile
}

python_test() {
	cd "${BUILD_DIR}"/lib || die
	virtx "${EPYTHON}" -m 'rpy2.tests'
}
