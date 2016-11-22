# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit kde4-base

DESCRIPTION="FFmpeg based thumbnail generator for video files"
SRC_URI="mirror://kde/Attic/applications/${PV}/src/${P}.tar.xz"

KEYWORDS="amd64 ~arm x86"
IUSE="debug"

DEPEND="
	virtual/ffmpeg
"
RDEPEND="${DEPEND}
	$(add_kdeapps_dep kdebase-kioslaves)
"
