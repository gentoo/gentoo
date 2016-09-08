# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit autotools

MY_P="${PN^^[gasn]}-${PV}"
DESCRIPTION="Networking middleware for partitioned global address space (PGAS) language"
HOMEPAGE="http://gasnet.lbl.gov/"
SRC_URI="http://gasnet.lbl.gov/${MY_P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
IUSE="mpi threads"

DEPEND="mpi? ( virtual/mpi )"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	find . \
		\( -name Makefile.am -or -name "*.mak" \) \
		-exec sed -i '/^docdir/s/^/#/' {} + || die
	default
	eautoreconf
}

src_configure() {
	econf $(use_enable mpi) $(use_enable threads pthreads)
}
