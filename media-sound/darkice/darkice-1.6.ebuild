# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="live audio streamer"
HOMEPAGE="http://www.darkice.org/"
SRC_URI="https://github.com/rafael2k/darkice/archive/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${P}/${PN}/trunk"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~ppc ~sparc ~x86"
ENCODERS="aac fdk flac mp3 opus twolame +vorbis"
OUTPUTS="+alsa jack pulseaudio"
IUSE="libsamplerate ${ENCODERS} ${OUTPUTS}"
REQUIRED_USE="
	|| ( ${ENCODERS//+/} )
	|| ( ${OUTPUTS//+/} )
	fdk? ( libsamplerate )
"

RDEPEND="
	aac? ( media-libs/faac )
	alsa? ( media-libs/alsa-lib )
	fdk? ( media-libs/fdk-aac:= )
	flac? (
		media-libs/flac:=
		media-libs/libogg
	)
	jack? ( virtual/jack )
	libsamplerate? ( media-libs/libsamplerate )
	mp3? ( media-sound/lame )
	opus? (
		media-libs/libogg
		media-libs/opus
	)
	pulseaudio? ( media-libs/libpulse )
	twolame? ( media-sound/twolame )
	vorbis? (
		media-libs/libogg
		media-libs/libvorbis
	)
"
DEPEND="${RDEPEND}"

src_prepare() {
	default

	eautoreconf
}

src_configure() {
	local myeconfargs=(
		$(use_with aac faac)
		$(use_with alsa)
		$(use_with fdk fdkaac)
		$(use_with flac)
		$(use_with jack)
		$(use_with libsamplerate samplerate)
		$(use_with mp3 lame)
		$(use_with opus)
		$(use_with pulseaudio)
		$(use_with twolame)
		$(use_with vorbis)
	)
	econf "${myeconfargs[@]}"
}

src_install() {
	default

	newinitd "${FILESDIR}"/${PN}.initd ${PN}
}
