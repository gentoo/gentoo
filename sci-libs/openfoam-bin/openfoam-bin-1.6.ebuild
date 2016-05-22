# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="2"

inherit eutils versionator multilib toolchain-funcs

MY_PN="OpenFOAM"
MY_PV=$(get_version_component_range 1-2)
MY_P="${MY_PN}-${MY_PV}"

DESCRIPTION="Open Field Operation and Manipulation - CFD Simulation Toolbox"
HOMEPAGE="http://www.opencfd.co.uk/openfoam/"
SRC_URI="mirror://sourceforge/foam/${MY_P}.General.gtgz -> ${MY_P}.General.tgz
	x86? ( mirror://sourceforge/foam/${MY_P}.linuxGccDPOpt.gtgz -> ${MY_P}.linuxGccDPOpt.tgz )
	amd64? ( mirror://sourceforge/foam/${MY_P}.linux64GccDPOpt.gtgz -> ${MY_P}.linux64GccDPOpt.tgz )
	mirror://gentoo/${MY_P}-compile.patch.bz2"

LICENSE="GPL-2"
SLOT="1.6"
KEYWORDS="-* ~amd64 ~x86"
IUSE="examples doc"

DEPEND="!=sci-libs/openfoam-${MY_PV}*
	!=sci-libs/openfoam-kernel-${MY_PV}*
	!=sci-libs/openfoam-meta-${MY_PV}*
	!=sci-libs/openfoam-solvers-${MY_PV}*
	!=sci-libs/openfoam-utilities-${MY_PV}*
	!=sci-libs/openfoam-wmake-${MY_PV}*
	sci-visualization/opendx
	virtual/mpi"
RDEPEND="${DEPEND}
	=sys-libs/ncurses-5*"

S=${WORKDIR}/${MY_P}
INSDIR="/usr/$(get_libdir)/${MY_PN}/${MY_P}"

pkg_setup() {
	## binaries are compiled with gcc-4.3.3
	if ! version_is_at_least 4.3 $(gcc-version) ; then
		die "${PN} requires >=sys-devel/gcc-4.3 in order to run."
	fi

	elog
	elog "In order to use ${MY_PN} you should add the following line to ~/.bashrc :"
	elog
	elog "alias startOF$(delete_all_version_separators ${MY_PV})='source ${INSDIR}/etc/bashrc'"
	elog
	elog "And everytime you want to use OpenFOAM you have to execute startOF$(delete_all_version_separators ${MY_PV})"
	ewarn
	ewarn "FoamX is deprecated since ${MY_PN}-1.5! "
	ewarn
}

src_prepare() {
	epatch "${WORKDIR}"/${MY_P}-compile.patch
}

src_configure() {
	if has_version sys-cluster/mpich2 ; then
		export WM_MPLIB=MPICH
		export MPI_VERSION=mpich
	elif has_version sys-cluster/openmpi ; then
		export WM_MPLIB=OPENMPI
		export MPI_VERSION=openmpi
	else
		die "You need one of the following mpi implementations: openmpi, mpich2"
	fi

	sed -i -e "s|WM_MPLIB:=OPENMPI|WM_MPLIB:="${WM_MPLIB}"|" etc/bashrc
	sed -i -e "s|setenv WM_MPLIB OPENMPI|setenv WM_MPLIB "${WM_MPLIB}"|" etc/cshrc

	use x86 && WM_OPTIONS="linuxGccDPOpt"
	use amd64 && WM_OPTIONS="linux64GccDPOpt"

	mv lib/${WM_OPTIONS}/$MPI_VERSION* lib/${WM_OPTIONS}/$MPI_VERSION
}

src_test() {
	cd bin
	./foamInstallationTest
}

src_install() {
	insinto ${INSDIR}
	doins -r etc

	use examples && doins -r tutorials

	insopts -m0755
	doins -r bin

	insinto ${INSDIR}/applications/bin
	doins -r applications/bin/${WM_OPTIONS}/*

	insinto ${INSDIR}/lib
	doins -r lib/${WM_OPTIONS}/*

	insinto ${INSDIR}/wmake
	doins -r wmake/*

	dodoc {doc/Guides-a4/*.pdf,README}

	if use doc ; then
		dohtml -r doc/Doxygen
	fi
}
