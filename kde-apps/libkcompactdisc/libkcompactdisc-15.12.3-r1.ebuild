# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit kde4-base

DESCRIPTION="KDE library for playing & ripping CDs"
KEYWORDS="amd64 ~arm x86"
IUSE="alsa debug"

DEPEND="
	media-libs/phonon[qt4]
	alsa? ( media-libs/alsa-lib )
"
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}/${PN}-15.12.3-alsa.patch" )

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_find_package alsa Alsa)
	)
	kde4-base_src_configure
}
