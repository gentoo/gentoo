# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="GNU readline wrapper"
HOMEPAGE="http://utopia.knoware.nl/~hlub/uck/rlwrap/"
SRC_URI="http://utopia.knoware.nl/~hlub/uck/rlwrap/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~mips ~ppc ~x86 ~ppc-aix ~x64-cygwin ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos"
IUSE="debug"

RDEPEND="sys-libs/readline:0="
DEPEND="${RDEPEND}"

src_configure() {
	econf \
		$(use_enable debug)
}
