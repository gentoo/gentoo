# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

SCM=""
if [ "${PV#9999}" != "${PV}" ] ; then
	SCM="git-r3"
	EGIT_REPO_URI="https://github.com/rtv/Stage"
fi

inherit ${SCM} cmake-utils

if [ "${PV#9999}" != "${PV}" ] ; then
	KEYWORDS=""
	SRC_URI=""
else
	KEYWORDS="~amd64"
	SRC_URI="https://github.com/rtv/Stage/archive/v${PV}.tar.gz -> ${P}.tar.gz"
fi

DESCRIPTION="The Stage Robot Simulator"
HOMEPAGE="http://rtv.github.io/Stage/"
LICENSE="GPL-2"
SLOT="0/4.3"
IUSE=""

RDEPEND="
	dev-libs/libltdl:0
	virtual/jpeg:0
	media-libs/libpng:0=
	sys-libs/zlib:0=
	x11-libs/fltk[opengl]
	virtual/glu
	virtual/opengl
"
DEPEND="${RDEPEND}
	virtual/pkgconfig"
