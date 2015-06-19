# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-cluster/libquo/libquo-1.2.ebuild,v 1.1 2014/11/19 21:33:27 ottxor Exp $

EAPI=5

inherit autotools-utils

DESCRIPTION="run-time tuning of process binding policies made easy"
HOMEPAGE="http://losalamos.github.io/libquo/"
SRC_URI="http://losalamos.github.io/${PN}/dists/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="
	virtual/mpi
	sys-process/numactl
	sys-apps/hwloc[numa,xml]
	"
RDEPEND="${DEPEND}"

AUTOTOOLS_IN_SOURCE_BUILD=1

src_configure() {
	autotools-utils_src_configure CC=mpicc
}
