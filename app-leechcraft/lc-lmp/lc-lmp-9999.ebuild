# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit leechcraft

DESCRIPTION="LeechCraft Media Player, Phonon-based audio/video player"

SLOT="0"
KEYWORDS=""
IUSE="debug +fradj +graffiti +guess +mpris +mtp +mp3tunes potorchu"

# depend on gstreamer:0.10 to match current Qt deps
DEPEND="~app-leechcraft/lc-core-${PV}
		dev-qt/qtnetwork:5
		dev-qt/qtwidgets:5
		dev-qt/qtdeclarative:5[widgets]
		dev-qt/qtsql:5[sqlite]
		dev-qt/qtconcurrent:5
		dev-qt/qtxml:5
		media-libs/gstreamer:1.0

		mpris? ( dev-qt/qtdbus:5 )
		guess? ( app-i18n/libguess )
		media-libs/taglib
		mtp? ( media-libs/libmtp )
		potorchu? ( media-libs/libprojectm )"
RDEPEND="${DEPEND}
		mtp? ( ~app-leechcraft/lc-devmon-${PV} )
		graffiti? ( media-libs/flac )"

src_configure() {
	local mycmakeargs=(
		-DENABLE_LMP_FRADJ=$(usex fradj)
		-DENABLE_LMP_GRAFFITI=$(usex graffiti)
		-DENABLE_LMP_LIBGUESS=$(usex guess)
		-DENABLE_LMP_MPRIS=$(usex mpris)
		-DENABLE_LMP_MTPSYNC=$(usex mtp)
		-DENABLE_LMP_MP3TUNES=$(usex mp3tunes)
		-DENABLE_LMP_POTORCHU=$(usex potorchu)
	)
	cmake-utils_src_configure
}
