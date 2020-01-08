# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="Compute rank-width decompositions of graphs"
HOMEPAGE="https://sourceforge.net/projects/rankwidth/"
SRC_URI="https://downloads.sourceforge.net/project/rankwidth/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos"
IUSE="+executable"

DEPEND="executable? ( >=dev-libs/igraph-0.6 )"

# We have a file collision (librw.so) with xpaint, bug 560210.
RDEPEND="${DEPEND}
	!media-gfx/xpaint"

DOCDIR="/usr/share/doc/${PF}"

src_prepare() {
	# The upstream tarball for v0.8 contains SYMLINKS to ar-lib,
	# compile, install-sh, ltmain.sh, etc. And those symlinks don't
	# always point to a working location for us, so we have to
	# (re)generate actual files for that stuff. Bug 696986.
	eautoreconf
	default
}

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
