# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_HANDBOOK="forceoptional"
KFMIN=5.115.0
QTMIN=5.15.12
inherit ecm gear.kde.org

DESCRIPTION="Sound editor built on KDE Frameworks 5 that can edit many types of audio files"
HOMEPAGE="https://apps.kde.org/kwave/"

LICENSE="CC-BY-SA-3.0 CC0-1.0 GPL-2+ LGPL-2+ handbook? ( FDL-1.2 ) opus? ( BSD-2 )"
SLOT="5"
KEYWORDS="~amd64 arm64 ~ppc64 ~riscv ~x86"
IUSE="alsa flac mp3 opus oss pulseaudio +qtmedia vorbis"

RDEPEND="
	>=dev-qt/qtgui-${QTMIN}:5
	>=dev-qt/qtwidgets-${QTMIN}:5
	>=kde-frameworks/kcompletion-${KFMIN}:5
	>=kde-frameworks/kconfig-${KFMIN}:5
	>=kde-frameworks/kconfigwidgets-${KFMIN}:5
	>=kde-frameworks/kcoreaddons-${KFMIN}:5
	>=kde-frameworks/kcrash-${KFMIN}:5
	>=kde-frameworks/kdbusaddons-${KFMIN}:5
	>=kde-frameworks/ki18n-${KFMIN}:5
	>=kde-frameworks/kiconthemes-${KFMIN}:5
	>=kde-frameworks/kio-${KFMIN}:5
	>=kde-frameworks/ktextwidgets-${KFMIN}:5
	>=kde-frameworks/kwidgetsaddons-${KFMIN}:5
	>=kde-frameworks/kxmlgui-${KFMIN}:5
	media-libs/audiofile:=
	>=sci-libs/fftw-3:=
	media-libs/libsamplerate
	alsa? ( media-libs/alsa-lib )
	flac? ( media-libs/flac:=[cxx] )
	mp3? (
		media-libs/id3lib
		media-libs/libmad
		|| (
			media-sound/lame
			media-sound/toolame
			media-sound/twolame
		)
	)
	qtmedia? ( >=dev-qt/qtmultimedia-${QTMIN}:5 )
	opus? (
		media-libs/libogg
		media-libs/opus
	)
	pulseaudio? ( media-libs/libpulse )
	vorbis? (
		media-libs/libogg
		media-libs/libvorbis
	)
"
DEPEND="${RDEPEND}
	>=dev-qt/qtconcurrent-${QTMIN}:5
"
BDEPEND="
	sys-devel/gettext
	handbook? ( || (
		gnome-base/librsvg
		virtual/imagemagick-tools[png,svg]
	) )
"

DOCS=( AUTHORS CHANGES LICENSES README TODO )

src_configure() {
	local mycmakeargs=(
		-DDEBUG=$(usex debug)
		-DWITH_ALSA=$(usex alsa)
		-DWITH_DOC=$(usex handbook)
		-DWITH_FLAC=$(usex flac)
		-DWITH_MP3=$(usex mp3)
		-DWITH_OGG_VORBIS=$(usex vorbis)
		-DWITH_OGG_OPUS=$(usex opus)
		-DWITH_OSS=$(usex oss)
		-DWITH_PULSEAUDIO=$(usex pulseaudio)
		-DWITH_QT_AUDIO=$(usex qtmedia)
	)

	ecm_src_configure
}
