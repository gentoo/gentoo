# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="The Process Management Interface (PMI) Exascale"
HOMEPAGE="https://openpmix.github.io/"
SRC_URI="https://github.com/openpmix/openpmix/releases/download/v${PV}/${P}.tar.bz2"

LICENSE="BSD"
SLOT="0"
# No support for 32-bit systems as of 4.2.8 (https://github.com/open-mpi/ompi/issues/11248)
KEYWORDS="~amd64 -x86 ~amd64-linux"
IUSE="debug +munge pmi"

RDEPEND="
	dev-libs/libevent:=
	sys-apps/hwloc:=
	sys-cluster/ucx
	sys-libs/zlib:=
	munge? ( sys-auth/munge )
	pmi? ( !sys-cluster/slurm )
"
DEPEND="${RDEPEND}"

src_configure() {
	econf \
		--disable-werror \
		$(use_enable debug) \
		$(use_with munge)
}

src_install() {
	default

	# bug #884765
	mv "${ED}"/usr/bin/pquery "${ED}"/usr/bin/pmix-pquery || die
}
