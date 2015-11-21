# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit kde4-base

DESCRIPTION="A Thumbnail Generator for Video Files on KDE filemanagers"
KEYWORDS=" ~amd64 ~x86"
IUSE="debug"

RDEPEND="
	$(add_kdeapps_dep kdebase-kioslaves)
"

src_configure() {
	local mycmakeargs=(
		-DENABLE_PHONON_SUPPORT=ON
	)

	kde4-base_src_configure
}
