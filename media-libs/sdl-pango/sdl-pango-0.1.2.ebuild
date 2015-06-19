# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/sdl-pango/sdl-pango-0.1.2.ebuild,v 1.8 2015/02/11 22:42:53 mr_bones_ Exp $

EAPI=5
inherit eutils

DESCRIPTION="connect the text rendering engine of GNOME to SDL"
HOMEPAGE="http://sdlpango.sourceforge.net/"
SRC_URI="mirror://sourceforge/sdlpango/SDL_Pango-${PV}.tar.gz
	http://zarb.org/~gc/t/SDL_Pango-0.1.2-API-adds.patch"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 hppa ia64 ppc sparc x86"
IUSE="static-libs"

RDEPEND="x11-libs/pango
	media-libs/libsdl[video]"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

S=${WORKDIR}/SDL_Pango-${PV}

src_unpack() {
	unpack SDL_Pango-${PV}.tar.gz
}

src_prepare() {
	epatch "${DISTDIR}"/SDL_Pango-0.1.2-API-adds.patch
}

src_configure() {
	econf \
		$(use_enable static-libs static)
}

src_install() {
	default
	if ! use static-libs ; then
		prune_libtool_files
	fi
}
