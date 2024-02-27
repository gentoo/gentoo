# Copyright 2009-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"
DESCRIPTION="Advanced IRC Client"
HOMEPAGE="https://www.kvirc.net/ https://github.com/kvirc/KVIrc"
CMAKE_MAKEFILE_GENERATOR="emake"
PYTHON_COMPAT=( python3_{10..12} )

inherit cmake flag-o-matic python-single-r1 xdg

if [[ "${PV}" == "9999" ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/kvirc/KVIrc"
else
	SRC_URI="https://github.com/kvirc/KVIrc/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~ppc ~ppc64 ~riscv ~x86"
	S="${WORKDIR}/KVIrc-${PV}"
fi

LICENSE="GPL-2+"
SLOT="0"
IUSE="audiofile +dbus dcc-video debug doc gsm kde +nls oss +perl +phonon profile +python spell +ssl theora webengine"
REQUIRED_USE="audiofile? ( oss ) python? ( ${PYTHON_REQUIRED_USE} )"

BDEPEND="dev-lang/perl:0
	virtual/pkgconfig
	doc? ( app-text/doxygen )
	kde? ( kde-frameworks/extra-cmake-modules:0 )
	nls? ( sys-devel/gettext )"
DEPEND="dev-qt/qtcore:5
	dev-qt/qtconcurrent:5
	dev-qt/qtgui:5
	dev-qt/qtmultimedia:5
	dev-qt/qtnetwork:5
	dev-qt/qtprintsupport:5
	dev-qt/qtsql:5
	dev-qt/qtwidgets:5
	dev-qt/qtx11extras:5
	dev-qt/qtxml:5
	sys-libs/zlib:0=
	x11-libs/libX11
	x11-libs/libXScrnSaver
	audiofile? ( media-libs/audiofile )
	dbus? ( dev-qt/qtdbus:5 )
	dcc-video? ( dev-qt/qtmultimedia:5[widgets] )
	kde? (
		kde-frameworks/kcoreaddons:5
		kde-frameworks/ki18n:5
		kde-frameworks/knotifications:5
		kde-frameworks/kservice:5
		kde-frameworks/kwindowsystem:5
		kde-frameworks/kxmlgui:5
	)
	perl? ( dev-lang/perl:0= )
	phonon? ( media-libs/phonon[qt5(+)] )
	python? ( ${PYTHON_DEPS} )
	spell? ( app-text/enchant:2 )
	ssl? ( dev-libs/openssl:0= )
	theora? (
		media-libs/libogg
		media-libs/libtheora
		media-libs/libvorbis
	)
	webengine? ( dev-qt/qtwebengine:5[widgets] )"
RDEPEND="${DEPEND}
	gsm? ( media-sound/gsm )"

DOCS=()

PATCHES=(
	"${FILESDIR}/kvirc-5.2.0-qtver.patch"
	"${FILESDIR}/kvirc-5.2.0-dccvideo.patch"
)

pkg_setup() {
	if use python; then
		python-single-r1_pkg_setup
	fi
}

src_prepare() {
	cmake_src_prepare

	if [[ "${PV}" == "9999" ]]; then
		KVIRC_GIT_REVISION="$(git show -s --format=%H)"
		KVIRC_GIT_SOURCES_DATE="$(git show -s --format=%cd --date=short)"
		einfo "Setting of revision number to ${KVIRC_GIT_REVISION} ${KVIRC_GIT_SOURCES_DATE}"
		sed -e "/#define KVI_DEFAULT_FRAME_CAPTION/s/KVI_VERSION/& \" (${KVIRC_GIT_REVISION} ${KVIRC_GIT_SOURCES_DATE})\"/" \
			-i src/kvirc/ui/KviMainWindow.cpp || die "Setting of revision number failed"
	fi
}

src_configure() {
	append-flags -fno-strict-aliasing

	local libdir="$(get_libdir)"
	local mycmakeargs=(
		-DLIB_SUFFIX=${libdir#lib}
		-DWANT_ENV_FLAGS=ON
		-DWANT_VERBOSE=ON

		-DWANT_CRYPT=ON
		-DWANT_DCC_VOICE=ON
		-DWANT_IPC=ON
		-DWANT_IPV6=ON
		-DWANT_TRANSPARENCY=ON

		-DWANT_AUDIOFILE=$(usex audiofile)
		-DWANT_DCC_VIDEO=$(usex dcc-video)
		-DWANT_DEBUG=$(usex debug)
		-DWANT_DOXYGEN=$(usex doc)
		-DWANT_GETTEXT=$(usex nls)
		-DWANT_GSM=$(usex gsm)
		-DWANT_KDE=$(usex kde)
		-DWANT_MEMORY_PROFILE=$(usex profile)
		-DWANT_OGG_THEORA=$(usex theora)
		-DWANT_OPENSSL=$(usex ssl)
		-DWANT_OSS=$(usex oss)
		-DWANT_PERL=$(usex perl)
		-DWANT_PHONON=$(usex phonon)
		-DWANT_PYTHON=$(usex python)
		-DWANT_QTDBUS=$(usex dbus)
		-DWANT_QTWEBENGINE=$(usex webengine)
		-DWANT_SPELLCHECKER=$(usex spell)
		-DQT_VERSION_MAJOR=5

		# COMPILE_SVG_SUPPORT not used in source code.
		-DWANT_QTSVG=OFF
	)
	if use python; then
		mycmakeargs+=(
			-DPython3_INCLUDE_DIR="$(python_get_includedir)"
			-DPython3_LIBRARY="$(python_get_library_path)"
		)
	fi
	if [[ "${PV}" == "9999" ]]; then
		mycmakeargs+=(
			-DMANUAL_REVISION=${KVIRC_GIT_REVISION}
			-DMANUAL_SOURCES_DATE=${KVIRC_GIT_SOURCES_DATE//-/}
		)
	fi

	cmake_src_configure
}

src_compile() {
	cmake_src_compile

	if use doc; then
		cmake_src_compile devdocs
	fi
}

src_install() {
	cmake_src_install

	if use doc; then
		(
			docinto html
			dodoc -r "${BUILD_DIR}/doc/api/html/"*
		)
	fi
}
