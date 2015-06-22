# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-mathematics/rw/rw-0.7.ebuild,v 1.1 2015/06/22 15:12:57 mjo Exp $

EAPI=5

inherit autotools-utils

DESCRIPTION="Compute rank-width decompositions of graphs"
AUTHORPAGE="http://pholia.tdi.informatik.uni-frankfurt.de/~philipp/"
HOMEPAGE="${AUTHORPAGE}software/${PN}.shtml"
SRC_URI="${AUTHORPAGE}/software/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~x64-macos"
IUSE="+executable static-libs"

DEPEND="executable? ( >=dev-libs/igraph-0.6 )"
RDEPEND="${DEPEND}"

DOCDIR="/usr/share/doc/${PF}"

AUTOTOOLS_IN_SOURCE_BUILD=1

src_configure(){
	local myeconfargs=(
		$(use_enable executable)
		--docdir="${EPREFIX}${DOCDIR}"
	)

	autotools-utils_src_configure
}

src_install(){
	# The examples graphs are meant to be fed uncompressed into the 'rw'
	# program. The rest of the docs are small so just leave everything
	# uncompressed.
	docompress -x "${DOCDIR}"
	autotools-utils_src_install
}
