# Copyright 2009-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"

PYTHON_COMPAT=( python3_{11..14} )
inherit cmake python-single-r1 xdg

DESCRIPTION="Advanced IRC Client"
HOMEPAGE="https://www.kvirc.net/ https://github.com/kvirc/KVIrc"

if [[ ${PV} == *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/kvirc/KVIrc"
else
	SRC_URI="https://github.com/kvirc/KVIrc/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/KVIrc-${PV}"
	KEYWORDS="~amd64 ~ppc ~ppc64 ~riscv ~x86"
fi

LICENSE="GPL-2+"
SLOT="0"
IUSE="audiofile +dbus debug doc gsm kde +nls oss +perl profile +python spell +ssl theora webengine"
REQUIRED_USE="audiofile? ( oss ) python? ( ${PYTHON_REQUIRED_USE} )"

BDEPEND="
	dev-lang/perl:0
	virtual/pkgconfig
	doc? ( app-text/doxygen )
	kde? ( kde-frameworks/extra-cmake-modules:0 )
	nls? ( sys-devel/gettext )"
DEPEND="
	dev-qt/qtbase:6[concurrent,gui,network,sql,widgets,xml]
	dev-qt/qtmultimedia:6
	dev-qt/qt5compat:6
	virtual/zlib:=
	x11-libs/libX11
	audiofile? ( media-libs/audiofile )
	dbus? ( dev-qt/qtbase:6[dbus] )
	kde? (
		kde-frameworks/kconfig:6
		kde-frameworks/kcoreaddons:6
		kde-frameworks/kio:6
		kde-frameworks/ki18n:6
		kde-frameworks/knotifications:6
		kde-frameworks/kparts:6
		kde-frameworks/kservice:6
		kde-frameworks/kstatusnotifieritem:6
		kde-frameworks/kwindowsystem:6[X]
		kde-frameworks/kxmlgui:6
	)
	perl? ( dev-lang/perl:0= )
	python? ( ${PYTHON_DEPS} )
	spell? ( app-text/enchant:2 )
	ssl? ( dev-libs/openssl:0= )
	theora? (
		media-libs/libogg
		media-libs/libtheora:=
		media-libs/libvorbis
	)
	webengine? ( dev-qt/qtwebengine:6[widgets] )"
RDEPEND="${DEPEND}
	gsm? ( media-sound/gsm )"

DOCS=()

pkg_setup() {
	if use python; then
		python-single-r1_pkg_setup
	fi
}

src_prepare() {
	cmake_src_prepare

	if [[ ${PV} == *9999* ]]; then
		KVIRC_GIT_REVISION="$(git show -s --format=%H)"
		KVIRC_GIT_SOURCES_DATE="$(git show -s --format=%cd --date=short)"
		einfo "Setting of revision number to ${KVIRC_GIT_REVISION} ${KVIRC_GIT_SOURCES_DATE}"
		sed -e "/#define KVI_DEFAULT_FRAME_CAPTION/s/KVI_VERSION/& \" (${KVIRC_GIT_REVISION} ${KVIRC_GIT_SOURCES_DATE})\"/" \
			-i src/kvirc/ui/KviMainWindow.cpp || die "Setting of revision number failed"
	fi
}

src_configure() {
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
		-DWANT_PYTHON=$(usex python)
		-DWANT_QTDBUS=$(usex dbus)
		-DWANT_QTWEBENGINE=$(usex webengine)
		-DWANT_SPELLCHECKER=$(usex spell)
		-DQT_VERSION_MAJOR=6

		-DWANT_DCC_VIDEO=OFF
		-DWANT_PHONON=OFF
		-DWANT_QTSVG=OFF # COMPILE_SVG_SUPPORT not used in source code.
	)
	if use python; then
		mycmakeargs+=(
			-DPython3_INCLUDE_DIR="$(python_get_includedir)"
			-DPython3_LIBRARY="$(python_get_library_path)"
		)
	fi
	if [[ ${PV} == *9999* ]]; then
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
		docinto html
		dodoc -r "${BUILD_DIR}/doc/api/html/"*
	fi
}
