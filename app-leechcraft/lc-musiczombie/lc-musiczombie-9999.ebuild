# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit leechcraft

DESCRIPTION="MusicBrainz client plugin for LeechCraft"

SLOT="0"
KEYWORDS=""
IUSE="acoustid debug"

DEPEND="~app-leechcraft/lc-core-${PV}
	dev-qt/qtconcurrent:5
	dev-qt/qtnetwork:5
	dev-qt/qtxml:5
	acoustid? ( media-libs/chromaprint:= )"
RDEPEND="${DEPEND}"

src_configure() {
	local mycmakeargs=(
		-DWITH_MUSICZOMBIE_CHROMAPRINT=$(usex acoustid)
	)
	cmake_src_configure
}
