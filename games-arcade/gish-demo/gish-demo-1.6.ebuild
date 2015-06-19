# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-arcade/gish-demo/gish-demo-1.6.ebuild,v 1.3 2015/02/25 15:57:31 ago Exp $

EAPI=5
inherit eutils games

DESCRIPTION="Play as an amorphous ball of tar that rolls and squishes around"
HOMEPAGE="http://www.chroniclogic.com/gish.htm"
SRC_URI="http://s159260531.onlinehome.us/demos/gishdemo.tar.gz -> ${P}.tar.gz"

LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="-* amd64 x86"
IUSE=""
RESTRICT="mirror bindist strip"
QA_PREBUILT="${GAMES_PREFIX_OPT:1}/${PN}/gish"

RDEPEND="media-libs/libsdl
	media-libs/libvorbis
	virtual/opengl
	x11-libs/libX11
	>=media-libs/openal-1.6.372"

S=${WORKDIR}/gishdemo

src_install() {
	local dir=${GAMES_PREFIX_OPT}/${PN}
	local gishbin=gishdemo
	use amd64 && gishbin=gishdemo_64

	insinto "${dir}"
	doins -r *
	fperms +x "${dir}"/${gishbin}
	games_make_wrapper gish ./${gishbin} "${dir}"
	prepgamesdirs
}
