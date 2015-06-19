# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-board/gnugo/gnugo-3.9.1-r1.ebuild,v 1.7 2015/06/03 04:14:43 jmorgan Exp $

EAPI=5
inherit eutils games

DESCRIPTION="A Go-playing program"
HOMEPAGE="http://www.gnu.org/software/gnugo/devel.html"
SRC_URI="mirror://gentoo/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 ~arm ppc ppc64 x86 ~amd64-linux ~x86-linux ~ppc-macos"
IUSE="readline"

DEPEND="readline? ( sys-libs/readline:0 )
	>=sys-libs/ncurses-5.2-r3"
RDEPEND=${DEPEND}

src_prepare() {
	epatch "${FILESDIR}"/${P}-invalid-move.patch
}

src_configure() {
	egamesconf \
		$(use_with readline) \
		--enable-cache-size=32
}

src_install() {
	default
	prepgamesdirs
}
