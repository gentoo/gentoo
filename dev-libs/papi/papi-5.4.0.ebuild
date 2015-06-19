# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/papi/papi-5.4.0.ebuild,v 1.1 2015/02/02 07:04:32 slis Exp $

EAPI=5

AUTOTOOLS_IN_SOURCE_BUILD=1
inherit autotools-utils fortran-2 versionator

DESCRIPTION="Performance Application Programming Interface"
HOMEPAGE="http://icl.cs.utk.edu/papi/"
SRC_URI="http://icl.cs.utk.edu/projects/${PN}/downloads/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="static-libs"

DEPEND="
	dev-libs/libpfm[static-libs]
	virtual/mpi
"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}-$(get_version_component_range 1-3)/src"

src_configure() {
	local myeconfargs=(
		--with-shlib
		--with-perf-events
		--with-pfm-prefix="${EPREFIX}/usr"
	)
	autotools-utils_src_configure
}

src_install() {
	autotools-utils_src_install
	dodoc ../RE*
}
