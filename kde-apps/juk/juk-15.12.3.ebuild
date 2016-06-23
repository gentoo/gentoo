# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

KDE_HANDBOOK="optional"
inherit kde4-base

DESCRIPTION="Jukebox and music manager for KDE"
HOMEPAGE="https://www.kde.org/applications/multimedia/juk/"
KEYWORDS="amd64 x86"
IUSE="debug"

DEPEND="
	>=media-libs/taglib-1.6
"
RDEPEND="${DEPEND}"

src_configure() {
	# https://bugs.gentoo.org/410551 for disabling deprecated TunePimp support
	local mycmakeargs=(
		-DWITH_TunePimp=OFF
	)

	kde4-base_src_configure
}
