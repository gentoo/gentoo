# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit flag-o-matic

DESCRIPTION="Virtual analogue synthesizer"
HOMEPAGE="https://github.com/amsynth/amsynth"
SRC_URI="https://github.com/${PN}/${PN}/releases/download/release-${PV}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="alsa dssi jack lash oss sndfile"

BDEPEND="
	virtual/pkgconfig
"
RDEPEND="
	alsa? (
		media-libs/alsa-lib:=
		media-sound/alsa-utils
	)
	dssi? (
		media-libs/dssi:=
		media-libs/liblo:=
		>=x11-libs/gtk+-2.20:2
	)
	jack? ( virtual/jack )
	lash? ( media-sound/lash )
	sndfile? ( >=media-libs/libsndfile-1:= )
"
DEPEND="${RDEPEND}
	oss? ( virtual/os-headers )
"

src_configure() {
	append-cxxflags -std=c++11
	econf \
		$(use_with oss) \
		$(use_with alsa) \
		$(use_with jack) \
		$(use_with lash) \
		$(use_with sndfile) \
		$(use_with dssi)
}
