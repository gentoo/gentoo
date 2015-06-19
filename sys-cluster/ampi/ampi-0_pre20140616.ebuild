# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-cluster/ampi/ampi-0_pre20140616.ebuild,v 1.1 2014/06/16 21:14:19 jauhien Exp $

EAPI=5

inherit autotools

DESCRIPTION="MPI library for algorithmic differentiation"
HOMEPAGE="http://www.mcs.anl.gov/~utke/AdjoinableMPI/AdjoinableMPIDox/index.html"
SRC_URI="http://dev.gentoo.org/~jauhien/distfiles/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="virtual/mpi"
DEPEND="${RDEPEND}"

src_prepare() {
	eautoreconf
}
