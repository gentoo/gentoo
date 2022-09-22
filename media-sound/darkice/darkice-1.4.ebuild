# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit flag-o-matic

DESCRIPTION="A live audio streamer"
HOMEPAGE="http://www.darkice.org/"
SRC_URI="https://github.com/rafael2k/${PN}/releases/download/v${PV}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 ~hppa ppc sparc x86"
IUSE="aac alsa debug jack libsamplerate mp3 opus pulseaudio twolame vorbis"

RDEPEND="aac? ( media-libs/faac )
	alsa? ( media-libs/alsa-lib )
	jack? ( virtual/jack )
	libsamplerate? ( media-libs/libsamplerate )
	mp3? ( media-sound/lame )
	opus? ( media-libs/opus )
	pulseaudio? ( media-sound/pulseaudio )
	twolame? ( media-sound/twolame )
	vorbis? ( media-libs/libvorbis )"
DEPEND="${RDEPEND}"

REQUIRED_USE="|| ( aac mp3 opus twolame vorbis )
		|| ( alsa jack pulseaudio )"

DOCS=( AUTHORS ChangeLog FAQ NEWS README TODO )

PATCHES=(
	"${FILESDIR}/${PN}-1.3-include.patch"
)

src_configure() {
	# bug #787161
	append-cxxflags -std=c++14

	local myeconfargs=(
		$(use_enable debug)
		$(use_with aac faac)
		--without-aacplus
		$(use_with alsa)
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

	einstalldocs
}
