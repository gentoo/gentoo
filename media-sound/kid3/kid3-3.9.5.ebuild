# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )
inherit cmake kde.org python-any-r1 xdg

DESCRIPTION="Simple tag editor based on Qt"
HOMEPAGE="https://kid3.kde.org/"

if [[ ${KDE_BUILD_TYPE} != live ]]; then
	SRC_URI="mirror://kde/stable/${PN}/${PV}/${P}.tar.xz"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-2+"
SLOT="5"
IUSE="acoustid flac kde mp3 mp4 +mpris +taglib test vorbis"

REQUIRED_USE="flac? ( vorbis )"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-qt/qtcore:5
	dev-qt/qtdeclarative:5
	dev-qt/qtgui:5
	dev-qt/qtmultimedia:5
	dev-qt/qtnetwork:5
	dev-qt/qtwidgets:5
	dev-qt/qtxml:5
	sys-libs/readline:=
	acoustid? (
		media-libs/chromaprint:=
		media-video/ffmpeg:=
	)
	flac? (
		media-libs/flac:=[cxx]
		media-libs/libvorbis
	)
	kde? (
		kde-frameworks/kconfig:5
		kde-frameworks/kconfigwidgets:5
		kde-frameworks/kcoreaddons:5
		kde-frameworks/kio:5
		kde-frameworks/kwidgetsaddons:5
		kde-frameworks/kxmlgui:5
	)
	mp3? ( media-libs/id3lib )
	mp4? ( media-libs/libmp4v2 )
	mpris? ( dev-qt/qtdbus:5 )
	taglib? ( >=media-libs/taglib-1.9.1 )
	vorbis? (
		media-libs/libogg
		media-libs/libvorbis
	)
"
DEPEND="${RDEPEND}
	test? ( dev-qt/qttest:5 )
"
BDEPEND="${PYTHON_DEPS}
	dev-qt/linguist-tools:5
	kde? ( kde-frameworks/extra-cmake-modules:0 )
"

pkg_setup() {
	use test && python-any-r1_pkg_setup
}

src_prepare() {
	# overengineered upstream build system
	cmake_src_prepare
	# applies broken python hacks, bug #614950
	cmake_comment_add_subdirectory doc

	sed -e "/^ *find_package.*QT NAMES/s/Qt6 //" \
		-i CMakeLists.txt || die # ensure Qt5 build
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_WITH_QT6=OFF
		-DWITH_QAUDIODECODER=ON # bug 855281
		-DWITH_CHROMAPRINT=$(usex acoustid)
		-DWITH_DBUS=$(usex mpris)
		-DWITH_FLAC=$(usex flac)
		-DWITH_ID3LIB=$(usex mp3)
		-DWITH_MP4V2=$(usex mp4)
		-DWITH_TAGLIB=$(usex taglib)
		-DBUILD_TESTING=$(usex test)
		-DWITH_VORBIS=$(usex vorbis)
	)

	if use kde ; then
		mycmakeargs+=( "-DWITH_APPS=KDE;CLI" )
	else
		mycmakeargs+=( "-DWITH_APPS=Qt;CLI" )
	fi

	cmake_src_configure
}
