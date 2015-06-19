# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-leechcraft/lc-lmp/lc-lmp-0.6.65.ebuild,v 1.2 2014/08/10 17:56:30 slyfox Exp $

EAPI="4"

inherit leechcraft

DESCRIPTION="LeechCraft Media Player, Phonon-based audio/video player"

SLOT="0"
KEYWORDS=" ~amd64 ~x86"
IUSE="debug +graffiti +guess +mpris +mp3tunes"

# depend on gstreamer:0.10 to match current Qt deps
DEPEND="~app-leechcraft/lc-core-${PV}
		graffiti? ( media-libs/flac )
		guess? ( app-i18n/libguess )
		media-libs/gstreamer:0.10
		media-libs/taglib
		mpris? ( dev-qt/qtdbus:4 )
		dev-qt/qtdeclarative:4"
RDEPEND="${DEPEND}"

src_configure() {
	local mycmakeargs="
		$(cmake-utils_use_enable graffiti LMP_GRAFFITI)
		$(cmake-utils_use_enable guess LMP_LIBGUESS)
		$(cmake-utils_use_enable mpris LMP_MPRIS)
		$(cmake-utils_use_enable mp3tunes LMP_MP3TUNES)"
	cmake-utils_src_configure
}
