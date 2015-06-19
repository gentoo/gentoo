# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-leechcraft/lc-lmp/lc-lmp-9999.ebuild,v 1.7 2015/03/22 16:46:31 maksbotan Exp $

EAPI="4"

inherit leechcraft

DESCRIPTION="LeechCraft Media Player, Phonon-based audio/video player"

SLOT="0"
KEYWORDS=""
IUSE="debug +fradj +graffiti +guess +mpris +mtp +mp3tunes potorchu"

# depend on gstreamer:0.10 to match current Qt deps
DEPEND="~app-leechcraft/lc-core-${PV}
		graffiti? ( media-libs/flac )
		guess? ( app-i18n/libguess )
		media-libs/gstreamer:0.10
		media-libs/taglib
		mpris? ( dev-qt/qtdbus:4 )
		mtp? (
			~app-leechcraft/lc-devmon-${PV}
			media-libs/libmtp
		)
		potorchu? ( media-libs/libprojectm )
		dev-qt/qtdeclarative:4"
RDEPEND="${DEPEND}"

src_configure() {
	local mycmakeargs="
		$(cmake-utils_use_enable fradj LMP_FRADJ)
		$(cmake-utils_use_enable graffiti LMP_GRAFFITI)
		$(cmake-utils_use_enable guess LMP_LIBGUESS)
		$(cmake-utils_use_enable mpris LMP_MPRIS)
		$(cmake-utils_use_enable mtp LMP_MTPSYNC)
		$(cmake-utils_use_enable mp3tunes LMP_MP3TUNES)
		$(cmake-utils_use_enable potorchu LMP_POTORCHU)"
	cmake-utils_src_configure
}
