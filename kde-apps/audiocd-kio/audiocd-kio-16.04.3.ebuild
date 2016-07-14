# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

KDE_HANDBOOK="optional"
inherit kde4-base

DESCRIPTION="KDE kioslaves from the kdemultimedia package"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="debug flac vorbis"

DEPEND="
	$(add_kdeapps_dep libkcddb)
	$(add_kdeapps_dep libkcompactdisc)
	media-sound/cdparanoia
	flac? ( >=media-libs/flac-1.1.2 )
	vorbis? (
		media-libs/libogg
		media-libs/libvorbis
	)
"
RDEPEND="${DEPEND}"

src_configure() {
	local mycmakeargs=(
		-DWITH_Flac=$(usex flac)
		-DWITH_OggVorbis=$(usex vorbis)
	)

	kde4-base_src_configure
}
