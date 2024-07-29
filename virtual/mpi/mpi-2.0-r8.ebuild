# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit multilib-build

DESCRIPTION="Virtual for Message Passing Interface (MPI) v2.0 implementation"

SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~loong ~ppc ppc64 ~riscv sparc x86 ~amd64-linux ~x86-linux"
IUSE="cxx fortran romio threads nullmpi"

RDEPEND="|| (
	>=sys-cluster/openmpi-4.1.2[${MULTILIB_USEDEP},cxx(-)?,fortran?,romio?,threads(+)?]
	>=sys-cluster/mpich-3.4.3[${MULTILIB_USEDEP},cxx?,fortran?,romio?,threads?]
	sys-cluster/native-mpi
	nullmpi? ( sys-cluster/nullmpi[${MULTILIB_USEDEP},cxx(-)?,fortran(-)?,romio(-)?,threads(-)?] )
)"
