# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit gnustep-2

MY_P=${P/c/C}
DESCRIPTION="Free software and romantic music player for GNUstep"
HOMEPAGE="http://gap.nongnu.org/cynthiune/"
SRC_URI="https://savannah.nongnu.org/download/gap/${MY_P}.tar.gz"

KEYWORDS="~amd64 ~ppc ~x86"
LICENSE="GPL-2"
SLOT="0"

IUSE="alsa ao flac mad modplug musepack oss timidity vorbis"

# musicbrainz disabled upstream for now
RDEPEND="media-libs/audiofile:=
	media-libs/taglib
	alsa? ( media-libs/alsa-lib )
	ao? ( media-libs/libao:= )
	flac? ( media-libs/flac:= )
	mad? (
		media-libs/libid3tag:=
		media-libs/libmad
	)
	musepack? ( >=media-sound/musepack-tools-444 )
	modplug? ( media-libs/libmodplug )
	timidity? ( media-sound/timidity++ )
	vorbis? (
		>=media-libs/libogg-1.1.2
		>=media-libs/libvorbis-1.0.1-r2
	)"
DEPEND="${RDEPEND}"
BDEPEND="mad? ( virtual/pkgconfig )"

S=${WORKDIR}/${MY_P}

cynthiune_get_config() {
	local myconf="disable-windowsmedia=yes disable-esound=yes"
	use alsa || myconf="${myconf} disable-alsa=yes"
	use ao || myconf="${myconf} disable-ao=yes"
	use flac || myconf="${myconf} disable-flac=yes disable-flactags=yes"
	use mad || myconf="${myconf} disable-mp3=yes disable-id3tag=yes"
	use modplug || myconf="${myconf} disable-mod=yes"
	use musepack || myconf="${myconf} disable-musepack=yes"
	use oss || myconf="${myconf} disable-oss=yes"
	use timidity || myconf="${myconf} disable-timidity=yes"
	use vorbis || myconf="${myconf} disable-ogg=yes disable-vorbistags=yes"

	echo ${myconf}
}

src_compile() {
	egnustep_env
	egnustep_make "$(cynthiune_get_config)"
}

src_install() {
	egnustep_env
	egnustep_install "$(cynthiune_get_config)"
}
