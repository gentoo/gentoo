# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Compute rank-width decompositions of graphs"
HOMEPAGE="https://sourceforge.net/projects/rankwidth/"
SRC_URI="https://downloads.sourceforge.net/project/rankwidth/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos"
IUSE=""

# We have a file collision (librw.so) with xpaint, bug 560210.
RDEPEND="!media-gfx/xpaint"

src_configure() {
	# The executable depends on igraph, which has gone off the rails
	# upstream and has copy/pasted ~10 libraries into its src/ directory.
	econf --disable-executable --disable-static
}

src_install() {
	default

	find "${ED}" -name '*.la' -delete \
		|| die 'failed to delete libtool archives'
}
