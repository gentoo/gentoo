# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit multilib cmake-utils

DESCRIPTION="Streaming audio processing library."
HOMEPAGE="https://github.com/andrewrk/libgroove"
SRC_URI="https://github.com/andrewrk/libgroove/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0/4"
KEYWORDS="~amd64"
IUSE="+chromaprint libav +loudness +sound static-libs"

DEPEND="libav? ( media-video/libav )
	!libav? ( media-video/ffmpeg )
	chromaprint? ( media-libs/chromaprint )
	loudness? ( media-libs/libebur128[speex] )
	sound? ( media-libs/libsdl2[sound] )"
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}/${P}_cflags.patch"
	"${FILESDIR}/${P}_GNUInstallDirs.patch" )

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_disable chromaprint FINGERPRINTER)
		$(cmake-utils_use_disable loudness LOUDNESS)
		$(cmake-utils_use_disable sound PLAYER)
	)
	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install

	if ! use static-libs ; then
		rm "${ED%/}"/usr/$(get_libdir)/*.a || die "failed to remove static libs"
	fi
}
