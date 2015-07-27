# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/amsynth/amsynth-1.5.1.ebuild,v 1.1 2015/07/27 14:46:51 polynomial-c Exp $

EAPI=5

inherit autotools

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

DOCS="AUTHORS README"

S="${WORKDIR}/${PN}-release-${PV}"

src_prepare() {
	eautoreconf
}

src_configure() {
	econf \
		CFLAGS="" \
		CXXFLAGS="${CXXFLAGS}" \
		$(use_with oss) \
		$(use_with alsa) \
		$(use_with jack) \
		$(use_with lash) \
		$(use_with sndfile) \
		$(use_with dssi)
}
