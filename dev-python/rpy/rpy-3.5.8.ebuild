# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..11} )
PYTHON_REQ_USE="sqlite"
DISTUTILS_USE_PEP517=setuptools

inherit distutils-r1 pypi virtualx

MYSLOT=2
MY_PN=${PN}${MYSLOT}
MY_P=${MY_PN}-${PV}

DESCRIPTION="Python interface to the R Programming Language"
HOMEPAGE="
	https://rpy.sourceforge.io/
	https://pypi.org/project/rpy2/
"
SRC_URI="$(pypi_sdist_url rpy2)"
S="${WORKDIR}/${MY_P}"

LICENSE="AGPL-3 GPL-2 LGPL-2.1 MPL-1.1"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"

# ggplot2 is a test dep but not in ::gentoo atm
RESTRICT="test"

RDEPEND="
	>=dev-lang/R-3.2
	dev-python/cffi[${PYTHON_USEDEP}]
	dev-python/jinja[${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]
	>=dev-python/pandas-0.13.1[${PYTHON_USEDEP}]
	dev-python/pytz[${PYTHON_USEDEP}]
	dev-python/tzlocal[${PYTHON_USEDEP}]
"
PDEPEND="dev-python/ipython[${PYTHON_USEDEP}]"

python_test() {
	cd "${BUILD_DIR}"/lib || die
	virtx "${EPYTHON}" -m 'rpy2.tests'
}
