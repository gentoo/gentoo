# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

KDE_HANDBOOK="optional"
inherit kde5

DESCRIPTION="Simple tag editor based on Qt"
HOMEPAGE="http://kid3.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="5"
KEYWORDS="~amd64 ~x86"
IUSE="acoustid flac kde mp3 mp4 +taglib vorbis"

REQUIRED_USE="flac? ( vorbis )"

COMMON_DEPEND="
	$(add_qt_dep qtdbus)
	$(add_qt_dep qtdeclarative)
	$(add_qt_dep qtgui)
	$(add_qt_dep qtmultimedia)
	$(add_qt_dep qtnetwork)
	$(add_qt_dep qtwidgets)
	$(add_qt_dep qtxml)
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
		$(add_frameworks_dep kconfig)
		$(add_frameworks_dep kconfigwidgets)
		$(add_frameworks_dep kcoreaddons)
		$(add_frameworks_dep kwidgetsaddons)
		$(add_frameworks_dep kxmlgui)
	)
	mp3? ( media-libs/id3lib )
	mp4? ( media-libs/libmp4v2:0 )
	taglib? ( >=media-libs/taglib-1.9.1 )
	vorbis? (
		media-libs/libogg
		media-libs/libvorbis
	)
"
RDEPEND="${COMMON_DEPEND}
	!media-sound/kid3:4
"
DEPEND="${COMMON_DEPEND}
	$(add_qt_dep linguist-tools)
"

PATCHES=(
	"${FILESDIR}/${PN}-3.3.2-libdir.patch"
	"${FILESDIR}/${PN}-3.4.4-deps.patch"
)

src_prepare() {
	# overengineered upstream build system
	# kde5 eclass src_prepare leads to compile failure

	# only enable handbook when required
	if ! use_if_iuse handbook ; then
		cmake_comment_add_subdirectory ${KDE_DOC_DIR}
	fi

	cmake-utils_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DWITH_PHONON=OFF
		-DWITH_QT4=OFF
		-DWITH_QT5=ON
		-DWITH_CHROMAPRINT=$(usex acoustid)
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

	kde5_src_configure
}
