# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit multilib-build

DESCRIPTION="Virtual for Message Passing Interface (MPI) v2.0 implementation"
HOMEPAGE=""
SRC_URI=""
LICENSE=""
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ppc ~ppc64 ~x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux"
IUSE="cxx fortran romio threads"

RDEPEND="|| (
	>=sys-cluster/openmpi-1.10.2-r1[${MULTILIB_USEDEP},cxx?,fortran?,romio?,threads?]
	>=sys-cluster/mpich-3.2-r1[${MULTILIB_USEDEP},cxx?,fortran?,romio?,threads?]
	sys-cluster/mpich2[cxx?,fortran?,romio?,threads?]
	sys-cluster/mvapich2[fortran?,romio?,threads?]
	sys-cluster/nullmpi[${MULTILIB_USEDEP},cxx(-)?,fortran(-)?,romio(-)?,threads(-)?]
	sys-cluster/native-mpi
)"

DEPEND=""
