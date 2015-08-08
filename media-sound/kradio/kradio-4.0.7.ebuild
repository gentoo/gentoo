# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

KDE_LINGUAS_DIR=( po convert-presets/po )
PLUGINS=(
	alsa-sound dbus gui-docking-menu gui-error-log gui-quickbar
	gui-standard-display internetradio lirc oss-sound radio recording shortcuts
	soundserver streaming timecontrol timeshifter v4lradio
)
KDE_LINGUAS="cs de es is it pl pt pt_BR ru sk tr uk"
inherit kde4-base

MY_P=${PN}4-${PV/_/-}

DESCRIPTION="kradio is a radio tuner application for KDE"
HOMEPAGE="http://kradio.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.bz2"

LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
SLOT="4"
IUSE="alsa debug encode ffmpeg lirc +mp3 +vorbis v4l"

DEPEND="
	media-libs/libsndfile
	alsa? ( media-libs/alsa-lib )
	ffmpeg? (
		>=media-libs/libmms-0.4
		virtual/ffmpeg
	)
	lirc? ( app-misc/lirc )
	mp3? ( media-sound/lame )
	vorbis? (
		media-libs/libvorbis
		media-libs/libogg
	)
"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${MY_P}

PATCHES=( "${FILESDIR}/${P}-include.patch" )

src_prepare() {
	local lang
	for lang in ${KDE_LINGUAS} ; do
		if ! use linguas_${lang} ; then
			for dir in "${KDE_LINGUAS_DIR[@]}" ; do
				rm ${dir}/${lang}.po
			done
			for plugin in "${PLUGINS[@]}" ; do
				rm plugins/${plugin}/po/${lang}.po
			done
		fi
	done

	kde4-base_src_prepare
}

src_configure() {
	mycmakeargs=(
		$(cmake-utils_use_with alsa)
		$(cmake-utils_use_with ffmpeg)
		$(cmake-utils_use_with lirc)
		$(cmake-utils_use_with mp3 LAME)
		$(cmake-utils_use_with vorbis OGG_VORBIS)
		$(cmake-utils_use_with v4l V4L2)
	)

	kde4-base_src_configure
}
