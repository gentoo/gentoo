# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-rpg/daimonin-client/daimonin-client-0.10.5.ebuild,v 1.6 2015/03/01 16:22:25 tupone Exp $

EAPI=5
inherit eutils autotools games

MY_P=${PN}-${PV}
DESCRIPTION="a graphical 2D tile-based MMORPG"
HOMEPAGE="http://daimonin.sourceforge.net/"
SRC_URI="http://daimonin.svn.sourceforge.net/viewvc/daimonin/main/client/?view=tar&pathrev=6021
			-> daimonin-client-0.10.5.tar.gz
		music? ( mirror://sourceforge/daimonin/Addon%20packs/Music/AllMusic.zip
			-> daimonin-client-AllMusic-20100827.zip )"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE="music debug"

RDEPEND="media-libs/libsdl[sound,video]
	media-libs/sdl-mixer[vorbis]
	media-libs/sdl-image[png]
	dev-games/physfs
	net-misc/curl"
DEPEND="${RDEPEND}
	music? ( app-arch/unzip )"

S=${WORKDIR}/client/make/linux

src_unpack() {
	unpack ${MY_P}.tar.gz
	if use music ; then
		cd client/media
		rm -f *
		unpack ${PN}-AllMusic-20100827.zip
	fi
}

src_prepare() {
	epatch "${FILESDIR}"/${P}-nozlib.patch
	rm ../../src/include/z{lib,conf}.h
	sed -i \
		-e 's:$(d_datadir):$(DESTDIR)$(d_datadir):' \
		-e '/PROGRAMS/s:daimonin-updater::' \
		Makefile.am \
		|| die "sed failed"
	eautoreconf
	cd ../../src
	epatch "${FILESDIR}"/${P}-datadir.patch
}

src_configure() {
	egamesconf \
		--disable-simplelayout \
		$(use_enable debug)
}

src_install() {
	default
	cd ../..
	dodoc README*
	newicon bitmaps/pentagram.png ${PN}.png
	make_desktop_entry daimonin Daimonin
	prepgamesdirs
}
