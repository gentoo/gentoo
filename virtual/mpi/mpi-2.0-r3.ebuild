# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

DESCRIPTION="Virtual for Message Passing Interface (MPI) v2.0 implementation"
HOMEPAGE=""
SRC_URI=""
LICENSE=""
SLOT="0"
KEYWORDS="alpha amd64 hppa ia64 ppc ppc64 sparc x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux"
IUSE="cxx fortran romio threads"

RDEPEND="|| (
	sys-cluster/openmpi[cxx?,fortran?,romio?,threads?]
	sys-cluster/mpich[cxx?,fortran?,romio?,threads?]
	sys-cluster/mpich2[cxx?,fortran?,romio?,threads?]
	sys-cluster/mvapich2[fortran?,romio?,threads?]
	sys-cluster/native-mpi
)"

DEPEND=""
