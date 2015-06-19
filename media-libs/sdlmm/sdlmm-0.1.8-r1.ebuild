# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/sdlmm/sdlmm-0.1.8-r1.ebuild,v 1.14 2015/03/31 16:27:06 mr_bones_ Exp $

MY_P=${P/sdl/SDL}

DESCRIPTION="A C++ Wrapper for the Simple DirectMedia Layer"
HOMEPAGE="http://sdlmm.sourceforge.net/"
SRC_URI="mirror://sourceforge/sdlmm/${MY_P}.tar.bz2"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ppc ~sparc x86"
IUSE=""

RDEPEND=">=media-libs/libsdl-1.2.4"
DEPEND="${RDEPEND}"

S=${WORKDIR}/${MY_P}

src_install() {
	emake DESTDIR="${D}" install || die
	dodoc AUTHORS README THANKS
}
