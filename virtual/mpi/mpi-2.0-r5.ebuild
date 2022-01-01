# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit multilib-build

DESCRIPTION="Virtual for Message Passing Interface (MPI) v2.0 implementation"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux"
IUSE="cxx fortran romio threads"

RDEPEND="|| (
	>=sys-cluster/openmpi-1.10.2-r1[${MULTILIB_USEDEP},cxx?,fortran?,romio?,threads(+)?]
	>=sys-cluster/mpich-3.2-r1[${MULTILIB_USEDEP},cxx?,fortran?,romio?,threads?]
	sys-cluster/mpich2[${MULTILIB_USEDEP},cxx?,fortran?,romio?,threads?]
	sys-cluster/nullmpi[${MULTILIB_USEDEP},cxx(-)?,fortran(-)?,romio(-)?,threads(-)?]
	sys-cluster/native-mpi
)"
