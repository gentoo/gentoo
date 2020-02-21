# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake xdg

DESCRIPTION="Simple tag editor based on Qt"
HOMEPAGE="https://kid3.sourceforge.io/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="5"
KEYWORDS="~amd64 ~x86"
IUSE="acoustid flac kde mp3 mp4 +mpris +taglib vorbis"

REQUIRED_USE="flac? ( vorbis )"

BDEPEND="
	dev-qt/linguist-tools:5
	kde? ( kde-frameworks/extra-cmake-modules:5 )
"
DEPEND="
	dev-qt/qtcore:5
	dev-qt/qtdeclarative:5
	dev-qt/qtgui:5
	dev-qt/qtmultimedia:5
	dev-qt/qtnetwork:5
	dev-qt/qtwidgets:5
	dev-qt/qtxml:5
	sys-libs/readline:0=
	acoustid? (
		media-libs/chromaprint
		virtual/ffmpeg
	)
	flac? (
		media-libs/flac[cxx]
		media-libs/libvorbis
	)
	kde? (
		kde-frameworks/kconfig:5
		kde-frameworks/kconfigwidgets:5
		kde-frameworks/kcoreaddons:5
		kde-frameworks/kwidgetsaddons:5
		kde-frameworks/kxmlgui:5
	)
	mp3? ( media-libs/id3lib )
	mp4? ( media-libs/libmp4v2:0 )
	mpris? ( dev-qt/qtdbus:5 )
	taglib? ( >=media-libs/taglib-1.9.1 )
	vorbis? (
		media-libs/libogg
		media-libs/libvorbis
	)
"
RDEPEND="${DEPEND}
	!media-sound/kid3:4
"

src_prepare() {
	# overengineered upstream build system
	cmake_src_prepare
	# applies broken python hacks, bug #614950
	cmake_comment_add_subdirectory doc
}

src_configure() {
	local mycmakeargs=(
		-DWITH_CHROMAPRINT=$(usex acoustid)
		-DWITH_DBUS=$(usex mpris)
		-DWITH_FLAC=$(usex flac)
		-DWITH_ID3LIB=$(usex mp3)
		-DWITH_MP4V2=$(usex mp4)
		-DWITH_TAGLIB=$(usex taglib)
		-DWITH_VORBIS=$(usex vorbis)
	)

	if use kde ; then
		mycmakeargs+=( "-DWITH_APPS=KDE;CLI" )
	else
		mycmakeargs+=( "-DWITH_APPS=Qt;CLI" )
	fi

	cmake_src_configure
}
