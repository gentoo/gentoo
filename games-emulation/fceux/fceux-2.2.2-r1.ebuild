# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils scons-utils games

DESCRIPTION="A portable Famicom/NES emulator, an evolution of the original FCE Ultra"
HOMEPAGE="http://fceux.com/"
SRC_URI="mirror://sourceforge/fceultra/${P}.src.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="gtk logo +lua +opengl"

DEPEND="lua? ( dev-lang/lua:0 )
	media-libs/libsdl[opengl?,video]
	logo? ( media-libs/gd[png] )
	opengl? ( virtual/opengl )
	gtk? ( x11-libs/gtk+:3 )
	sys-libs/zlib[minizip]"
RDEPEND=${DEPEND}

src_prepare() {
	epatch "${FILESDIR}"/${P}-warnings.patch
}

src_compile() {
	escons \
		GTK=0 \
		CREATE_AVI=1 \
		SYSTEM_LUA=1 \
		SYSTEM_MINIZIP=1 \
		$(use_scons gtk GTK3) \
		$(use_scons logo LOGO) \
		$(use_scons opengl OPENGL) \
		$(use_scons lua LUA)
}

src_install() {
	dogamesbin bin/fceux

	doman documentation/fceux.6
	docompress -x /usr/share/doc/${PF}/documentation /usr/share/doc/${PF}/fceux.chm
	dodoc -r Authors changelog.txt TODO-SDL bin/fceux.chm documentation
	rm -f "${D}/usr/share/doc/${PF}/documentation/fceux.6"
	make_desktop_entry fceux FCEUX
	doicon fceux.png
	prepgamesdirs
}
