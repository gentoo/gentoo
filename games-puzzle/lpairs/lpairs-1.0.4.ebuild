# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-puzzle/lpairs/lpairs-1.0.4.ebuild,v 1.7 2015/02/22 20:09:50 tupone Exp $

EAPI=5
inherit eutils games

DESCRIPTION="A classical memory game"
HOMEPAGE="http://lgames.sourceforge.net/index.php?project=LPairs"
SRC_URI="mirror://sourceforge/lgames/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE="nls"

RDEPEND="media-libs/libsdl
	nls? ( virtual/libintl )"
DEPEND="${RDEPEND}
	nls? ( sys-devel/gettext )"

src_prepare() {
	sed -i \
		-e 's:$localedir:/usr/share/locale:' \
		-e 's:$(localedir):/usr/share/locale:' \
		configure po/Makefile.in.in \
		|| die "sed failed"
}

src_configure() {
	egamesconf \
		--datadir="${GAMES_DATADIR_BASE}" \
		$(use_enable nls)
}

src_install() {
	default
	doicon lpairs.png
	make_desktop_entry lpairs LPairs
	prepgamesdirs
}
