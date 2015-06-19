# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-admin/logstalgia/logstalgia-1.0.3-r1.ebuild,v 1.1 2013/04/09 07:12:46 pinkbyte Exp $

EAPI="5"

DESCRIPTION="Replays or streams an access_log as a retro arcade game-like simulation"
HOMEPAGE="http://code.google.com/p/logstalgia/"
SRC_URI="http://logstalgia.googlecode.com/files/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="dev-libs/libpcre
	media-libs/libsdl[opengl]
	media-libs/libpng:0=
	media-libs/sdl-image
	media-libs/ftgl
	virtual/jpeg
	virtual/glu
	virtual/opengl"
DEPEND="${DEPEND}
	virtual/pkgconfig"

DOCS=( ChangeLog INSTALL README THANKS )
