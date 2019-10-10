# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit git-r3 cmake-multilib

DESCRIPTION="encoder and decoder of the ITU G729 Annex A/B speech codec"
HOMEPAGE="https://github.com/BelledonneCommunications/bcg729"
EGIT_REPO_URI="${HOMEPAGE}"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE="static-libs"
RDEPEND="
	!media-plugins/mediastreamer-bcg729
"

multilib_src_configure() {
	local mycmakeargs+=(
		-DENABLE_STATIC=$(usex static-libs)
	)
	cmake-utils_src_configure
}
