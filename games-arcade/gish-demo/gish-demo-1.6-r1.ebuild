# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit eutils

DESCRIPTION="Play as an amorphous ball of tar that rolls and squishes around"
HOMEPAGE="http://www.chroniclogic.com/gish.htm"
SRC_URI="http://www.chroniclogic.com/demos/gishdemo.tar.gz -> ${P}.tar.gz"

LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
IUSE=""
RESTRICT="mirror bindist strip"
QA_PREBUILT="${GAMES_PREFIX_OPT:1}/${PN}/gish"

RDEPEND="
	media-libs/libsdl
	media-libs/libvorbis
	virtual/opengl
	x11-libs/libX11
	>=media-libs/openal-1.6.372
"
DEPEND=""

S="${WORKDIR}/gishdemo"

src_install() {
	local dir=/opt/${PN}
	local gishbin=gishdemo
	use amd64 && gishbin=gishdemo_64

	insinto "${dir}"
	doins -r *
	fperms +x "${dir}"/${gishbin}
	make_wrapper gish ./${gishbin} "${dir}"

	einstalldocs
}
