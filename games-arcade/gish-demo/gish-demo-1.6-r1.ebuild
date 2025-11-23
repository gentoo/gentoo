# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit wrapper

DESCRIPTION="Play as an amorphous ball of tar that rolls and squishes around"
HOMEPAGE="http://www.chroniclogic.com/gish.htm"
SRC_URI="http://www.chroniclogic.com/demos/gishdemo.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}"/gishdemo

LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
RESTRICT="mirror bindist strip"
QA_PREBUILT="opt/${PN}/gish"

RDEPEND="
	>=media-libs/openal-1.6.372
	media-libs/libsdl
	media-libs/libvorbis
	virtual/opengl
	x11-libs/libX11
"

src_install() {
	local dir=/opt/${PN}
	local gishbin=gishdemo
	use amd64 && gishbin=gishdemo_64

	insinto ${dir}
	doins -r *
	fperms +x "${dir}"/${gishbin}
	make_wrapper gish ./${gishbin} "${dir}"

	einstalldocs
}
