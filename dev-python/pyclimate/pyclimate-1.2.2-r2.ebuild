# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/pyclimate/pyclimate-1.2.2-r2.ebuild,v 1.1 2015/02/23 14:46:43 idella4 Exp $

EAPI=5

PYTHON_COMPAT=( python2_7 )
DISTUTILS_SINGLE_IMPL=1

inherit distutils-r1

MY_P="${P/pyclimate/PyClimate}"

DESCRIPTION="Climate Data Analysis Module for Python"
HOMEPAGE="http://www.pyclimate.org/"
SRC_URI="http://fisica.ehu.es/jsaenz/pyclimate_files/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="examples"

DEPEND=""
RDEPEND="
	dev-python/numpy[${PYTHON_USEDEP}]
	>=dev-python/scientificpython-2.8[${PYTHON_USEDEP}]
	>=sci-libs/netcdf-3.0"

S="${WORKDIR}/${MY_P}"

pkg_setup() {
	python-single-r1_pkg_setup
}

python_install_all() {
	use examples && local EXAMPLES=( examples/. )
	distutils-r1_python_install_all
	dodoc doc/manual.ps doc/dcdflib_doc/dcdflib*
}
