# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DESCRIPTION="Compute rank-width decompositions of graphs"
AUTHORPAGE="http://pholia.tdi.informatik.uni-frankfurt.de/~philipp/"
HOMEPAGE="${AUTHORPAGE}software/${PN}.shtml"
SRC_URI="${AUTHORPAGE}software/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~amd64-linux ~x86 ~x86-linux ~ppc-macos ~x86-macos ~x64-macos"
IUSE="+executable"

DEPEND="executable? ( >=dev-libs/igraph-0.6 )"

# We have a file collision (librw.so) with xpaint, bug 560210.
RDEPEND="${DEPEND}
	!media-gfx/xpaint"

DOCDIR="/usr/share/doc/${PF}"

src_configure(){
	econf $(use_enable executable) --docdir="${EPREFIX}${DOCDIR}"
}

src_install(){
	# The examples graphs are meant to be fed uncompressed into the 'rw'
	# program. The rest of the docs are small so just leave everything
	# uncompressed.
	docompress -x "${DOCDIR}"
	default
}
