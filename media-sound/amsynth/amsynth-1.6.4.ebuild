# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit autotools flag-o-matic

DESCRIPTION="Virtual analogue synthesizer"
HOMEPAGE="https://github.com/nixxcode/amsynth/"
SRC_URI="https://github.com/nixxcode/${PN}/archive/release-${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="alsa dssi jack lash oss sndfile"

RDEPEND="dev-cpp/gtkmm:2.4
	sndfile? ( >=media-libs/libsndfile-1:= )
	alsa? (
		media-libs/alsa-lib:=
		media-sound/alsa-utils
		)
	dssi? (
		media-libs/dssi:=
		media-libs/liblo:=
		>=x11-libs/gtk+-2.20:2
		)
	jack? ( media-sound/jack-audio-connection-kit )
	lash? ( media-sound/lash )"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	oss? ( virtual/os-headers )"

S="${WORKDIR}/${PN}-release-${PV}"

src_prepare() {
	default
	eautoreconf
}

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
