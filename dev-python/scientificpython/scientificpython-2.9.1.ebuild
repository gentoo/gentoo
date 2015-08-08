# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="3"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.* *-jython 2.7-pypy-*"

inherit distutils eutils

MY_PN="ScientificPython"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Scientific Module for Python"
DOWNLOAD_NUMBER="3420"
SRC_URI="http://sourcesup.cru.fr/frs/download.php/${DOWNLOAD_NUMBER}/${MY_P}.tar.gz"
HOMEPAGE="http://sourcesup.cru.fr/projects/scientific-py/"

LICENSE="CeCILL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86 ~amd64-linux ~x86-linux"
IUSE="doc mpi test"

RDEPEND="
	<dev-python/numpy-1.9
	dev-python/pyro:3
	sci-libs/netcdf
	mpi? ( virtual/mpi )"
DEPEND="${RDEPEND}
	test? ( dev-python/nose )"

S="${WORKDIR}/${MY_P}"

PYTHON_CFLAGS=("2.* + -fno-strict-aliasing")

PYTHON_MODNAME="Scientific"

src_prepare() {
	distutils_src_prepare
	epatch "${FILESDIR}/${PN}-2.9-mpi.patch"
	use mpi && epatch "${FILESDIR}/${P}-mpi-netcdf.patch"
}

src_compile() {
	distutils_src_compile

	if use mpi; then
		cd Src/MPI
		building_of_mpipython() {
			PYTHONPATH="$(ls -d ../../build-${PYTHON_ABI}/lib*)" "$(PYTHON)" compile.py
			mv -f mpipython mpipython-${PYTHON_ABI}
		}
		python_execute_function \
			--action-message 'Building of mpipython with $(python_get_implementation) $(python_get_version)' \
			--failure-message 'Building of mpipython failed with $(python_get_implementation) $(python_get_version)' \
			building_of_mpipython
	fi
}

src_test() {
	cd Tests
	python_execute_nosetests -P '$(ls -d ../build-${PYTHON_ABI}/lib.*)'
}

src_install() {
	distutils_src_install
	# do not install bsp related stuff, since we don't compile the interface
	dodoc README README.MPI Doc/CHANGELOG || die "dodoc failed"
	insinto /usr/share/doc/${PF}
	doins Examples/{demomodule.c,netcdf_demo.py} || die "doins examples failed"

	if use mpi; then
		installation_of_mpipython() {
			dobin Src/MPI/mpipython-${PYTHON_ABI}
		}
		python_execute_function -q installation_of_mpipython
		python_generate_wrapper_scripts "${ED}usr/bin/mpipython"
		doins Examples/mpi.py || die "doins mpi example failed failed"
	fi

	if use doc; then
		dohtml Doc/Reference/* || die "dohtml failed"
	fi
}
