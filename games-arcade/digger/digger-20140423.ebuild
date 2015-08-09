# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils games

DESCRIPTION="Digger Remastered"
HOMEPAGE="http://www.digger.org/"
SRC_URI="https://gitorious.org/digger/digger/archive/8d5769c59d68b37a5b30aa7a9cbfa5a9e15e7ed3.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc ~ppc64 ~sparc x86 ~x86-fbsd"

DEPEND="media-libs/libsdl[X,video]
	x11-libs/libX11"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${PN}-${PN}

src_prepare() {
	epatch "${FILESDIR}"/${P}-ldflags.patch
}

src_install() {
	dogamesbin digger
	dodoc digger.txt
	make_desktop_entry digger Digger
	prepgamesdirs
}
