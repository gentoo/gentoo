# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="The Stage Robot Simulator"
HOMEPAGE="http://rtv.github.io/Stage/"
SRC_URI="https://github.com/rtv/Stage/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0/4.3"
KEYWORDS="~amd64"

RDEPEND="
	dev-libs/libltdl:0
	media-libs/libpng:0=
	sys-libs/zlib:0=
	x11-libs/fltk[opengl]
	virtual/glu
	virtual/jpeg:0
	virtual/opengl
"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/libdir.patch
)
