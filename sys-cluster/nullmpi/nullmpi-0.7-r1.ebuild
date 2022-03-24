# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools multilib-minimal

DESCRIPTION="MPI substitute library"
HOMEPAGE="http://wissrech.ins.uni-bonn.de/research/projects/nullmpi/"
SRC_URI="http://wissrech.ins.uni-bonn.de/research/projects/nullmpi/${P}.tar.gz"

LICENSE="GPL-1"
SLOT="0"
KEYWORDS="~amd64 ~riscv ~x86"

RDEPEND="
	!sys-cluster/openmpi
	!sys-cluster/mpich
	!sys-cluster/mpich2
	!sys-cluster/mvapich2
	!sys-cluster/native-mpi"
DEPEND="${RDEPEND}"

PATCHES=( "${FILESDIR}/${P}-libtool.patch" )

MULTILIB_WRAPPED_HEADERS=(
	/usr/include/nullmpi_conf.h
)

src_prepare() {
	default
	eautoreconf
}

multilib_src_configure() {
	ECONF_SOURCE="${S}" econf
}

multilib_src_install_all() {
	einstalldocs

	# no deps
	find "${ED}" -name '*.la' -delete || die
}
