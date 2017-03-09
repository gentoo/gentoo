# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit leechcraft

DESCRIPTION="MusicBrainz client plugin for LeechCraft"

SLOT="0"
KEYWORDS=""
IUSE="debug acoustid"

DEPEND="~app-leechcraft/lc-core-${PV}
	dev-qt/qtnetwork:5
	dev-qt/qtwidgets:5
	dev-qt/qtconcurrent:5
	dev-qt/qtnetwork:5
	dev-qt/qtxml:5
	acoustid? ( media-libs/chromaprint )"
RDEPEND="${DEPEND}"

src_configure() {
	local mycmakeargs=(
		-DWITH_MUSICZOMBIE_CHROMAPRINT=$(usex acoustid)
	)
	cmake-utils_src_configure
}
