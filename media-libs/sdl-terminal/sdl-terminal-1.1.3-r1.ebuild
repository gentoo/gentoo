# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils autotools

MY_P="${P/sdl-/SDL_}"
DESCRIPTION="library that provides a pseudo-ansi color terminal that can be used with any SDL application"
HOMEPAGE="https://sourceforge.net/projects/sdl-terminal/"
SRC_URI="mirror://gentoo/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="static-libs"

DEPEND="virtual/opengl
	virtual/glu
	>=media-libs/libsdl-1.2.4[opengl]
	media-libs/sdl-ttf"
RDEPEND=${DEPEND}

S=${WORKDIR}/${MY_P}

src_prepare() {
	epatch "${FILESDIR}"/${P}-nopython.patch
	eautoreconf
}

src_configure() {
	econf $(use_enable static-libs static)
}

src_install() {
	DOCS="AUTHORS ChangeLog README" \
		default
	prune_libtool_files
}
