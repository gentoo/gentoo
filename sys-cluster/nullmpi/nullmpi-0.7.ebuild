# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit autotools multilib-minimal

DESCRIPTION="MPI substitute library"
HOMEPAGE="http://wissrech.ins.uni-bonn.de/research/projects/nullmpi/"
SRC_URI="http://wissrech.ins.uni-bonn.de/research/projects/nullmpi/${PF}.tar.gz"

LICENSE="GPL-1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="static-libs"

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
	ECONF_SOURCE="${S}" econf --enable-shared $(use_enable static-libs static)
}

multilib_src_install_all() {
	einstalldocs

	#no deps
	find "${ED}" -name '*.la' -delete || die
}
