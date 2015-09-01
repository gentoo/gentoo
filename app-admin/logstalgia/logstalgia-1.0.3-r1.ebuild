# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

DESCRIPTION="Replays or streams an access_log as a retro arcade game-like simulation"
HOMEPAGE="http://logstalgia.io/"
SRC_URI="https://logstalgia.googlecode.com/files/${P}.tar.gz"

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
