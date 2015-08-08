# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

MY_PN="ScientificPython"
MY_P="${MY_PN}-${PV}"
DOWNLOAD_NUMBER=4425

DESCRIPTION="Scientific Module for Python"
SRC_URI="http://sourcesup.cru.fr/frs/download.php/${DOWNLOAD_NUMBER}/${MY_P}.tar.gz"
HOMEPAGE="http://sourcesup.cru.fr/projects/scientific-py/"

LICENSE="CeCILL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86 ~amd64-linux ~x86-linux"
IUSE="doc mpi test"

RDEPEND="
	<dev-python/numpy-1.9[${PYTHON_USEDEP}]
	dev-python/pyro:3[${PYTHON_USEDEP}]
	sci-libs/netcdf
	mpi? ( virtual/mpi )"
DEPEND="${RDEPEND}
	test? ( dev-python/nose[${PYTHON_USEDEP}] )"

S="${WORKDIR}/${MY_P}"

PATCHES=( "${FILESDIR}"/${PN}-2.9-mpi.patch )
DOCS=( README README.MPI Doc/CHANGELOG Examples/demomodule.c Examples/netcdf_demo.py )

python_prepare_all() {
	use mpi && PATCHES+=( "${FILESDIR}"/${PN}-2.9.3-mpi-netcdf.patch )
	distutils-r1_python_prepare_all
}

python_compile() {
	distutils-r1_python_compile

	if use mpi; then
		cd Src/MPI || die
		${PYTHON} compile.py || die
		mv -f mpipython mpipython-${EPYTHON} || die
	fi
}

python_test() {
	cd "${S}"/Tests || die
	python_foreach_impl nosetests
}

python_install() {
	distutils-r1_python_install

	if use mpi; then
		cd Src/MPI || die
		python_newexe mpipython-${EPYTHON} mpipython
	fi
}

python_install_all() {
	use doc && HTML_DOCS=( Doc/Reference/. )
	use mpi && EXAMPLES=( Examples/mpi.py )
	distutils-r1_python_install_all
}
