# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils games

DESCRIPTION="A classical memory game"
HOMEPAGE="http://lgames.sourceforge.net/index.php?project=LPairs"
SRC_URI="mirror://sourceforge/lgames/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE="nls sound"

RDEPEND="media-libs/libsdl[sound?,video]
	nls? ( virtual/libintl )"
DEPEND="${RDEPEND}
	nls? ( sys-devel/gettext )"

src_prepare() {
	sed -i \
		-e 's:$localedir:/usr/share/locale:' \
		-e 's:$(localedir):/usr/share/locale:' \
		configure po/Makefile.in.in || die
	# gcc5 doesn't like the way inline is used.  just punt it. (bug #568684)
	sed -i -e 's/^inline//g' lpairs/{sdl.[ch],pairs.[ch]} || die
}

src_configure() {
	egamesconf \
		--datadir="${GAMES_DATADIR_BASE}" \
		$(use_enable nls) \
		$(usex sound '' --disable-sound)
}

src_install() {
	default
	doicon lpairs.png
	make_desktop_entry lpairs LPairs
	prepgamesdirs
}
