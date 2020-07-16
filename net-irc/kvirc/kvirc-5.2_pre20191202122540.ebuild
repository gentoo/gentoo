# Copyright 2009-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"
CMAKE_MAKEFILE_GENERATOR="emake"
PYTHON_COMPAT=(python{3_6,3_7,3_8})

inherit cmake-utils flag-o-matic python-single-r1 xdg-utils

if [[ "${PV}" == "9999" ]]; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/kvirc/KVIrc"
	KVIRC_GIT_REVISION=""
	KVIRC_GIT_SOURCES_DATE=""
else
	KVIRC_GIT_REVISION="0df9f22f2f4d013b91d5a8905cbd47c32e8fb9e5"
	KVIRC_GIT_SOURCES_DATE="${PV#*_pre}"
	KVIRC_GIT_SOURCES_DATE="${KVIRC_GIT_SOURCES_DATE:0:4}-${KVIRC_GIT_SOURCES_DATE:4:2}-${KVIRC_GIT_SOURCES_DATE:6:2}"
fi

DESCRIPTION="Advanced IRC Client"
HOMEPAGE="https://www.kvirc.net/ https://github.com/kvirc/KVIrc"
if [[ "${PV}" == "9999" ]]; then
	SRC_URI=""
else
	SRC_URI="https://github.com/kvirc/KVIrc/archive/${KVIRC_GIT_REVISION}.tar.gz -> ${P}.tar.gz"
fi

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE="audiofile +dbus dcc_video debug doc gsm kde +nls oss +perl +phonon profile +python spell +ssl theora webkit"
REQUIRED_USE="audiofile? ( oss ) python? ( ${PYTHON_REQUIRED_USE} )"

BDEPEND="dev-lang/perl:0
	virtual/pkgconfig
	doc? ( app-doc/doxygen )
	kde? ( kde-frameworks/extra-cmake-modules:5 )
	nls? ( sys-devel/gettext )"
DEPEND="dev-qt/qtcore:5
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
	dcc_video? ( dev-qt/qtmultimedia:5[widgets] )
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
	spell? ( app-text/enchant:0= )
	ssl? ( dev-libs/openssl:0= )
	theora? (
		media-libs/libogg
		media-libs/libtheora
		media-libs/libvorbis
	)
	webkit? ( dev-qt/qtwebkit:5 )"
RDEPEND="${DEPEND}
	gsm? ( media-sound/gsm )"

if [[ "${PV}" != "9999" ]]; then
	S="${WORKDIR}/KVIrc-${KVIRC_GIT_REVISION}"
fi

PATCHES=(
	"${FILESDIR}/${PN}-5.2_pre20190628041642-python-3.patch"
)

DOCS=()

pkg_setup() {
	if use python; then
		python-single-r1_pkg_setup
	fi
}

src_prepare() {
	cmake-utils_src_prepare

	if [[ "${PV}" == "9999" ]]; then
		KVIRC_GIT_REVISION="$(git show -s --format=%H)"
		KVIRC_GIT_SOURCES_DATE="$(git show -s --format=%cd --date=short)"
	fi
	einfo "Setting of revision number to ${KVIRC_GIT_REVISION} ${KVIRC_GIT_SOURCES_DATE}"
	sed -e "/#define KVI_DEFAULT_FRAME_CAPTION/s/KVI_VERSION/& \" (${KVIRC_GIT_REVISION} ${KVIRC_GIT_SOURCES_DATE})\"/" -i src/kvirc/ui/KviMainWindow.cpp || die "Setting of revision number failed"
}

src_configure() {
	append-flags -fno-strict-aliasing

	local libdir="$(get_libdir)"
	local mycmakeargs=(
		-DLIB_SUFFIX=${libdir#lib}
		-DMANUAL_REVISION=${KVIRC_GIT_REVISION}
		-DMANUAL_SOURCES_DATE=${KVIRC_GIT_SOURCES_DATE//-/}
		-DWANT_ENV_FLAGS=ON
		-DWANT_VERBOSE=ON

		-DWANT_CRYPT=ON
		-DWANT_DCC_VOICE=ON
		-DWANT_IPC=ON
		-DWANT_IPV6=ON
		-DWANT_TRANSPARENCY=ON

		-DWANT_AUDIOFILE=$(usex audiofile ON OFF)
		-DWANT_DCC_VIDEO=$(usex dcc_video ON OFF)
		-DWANT_DEBUG=$(usex debug ON OFF)
		-DWANT_DOXYGEN=$(usex doc ON OFF)
		-DWANT_GETTEXT=$(usex nls ON OFF)
		-DWANT_GSM=$(usex gsm ON OFF)
		-DWANT_KDE=$(usex kde ON OFF)
		-DWANT_MEMORY_PROFILE=$(usex profile ON OFF)
		-DWANT_OGG_THEORA=$(usex theora ON OFF)
		-DWANT_OPENSSL=$(usex ssl ON OFF)
		-DWANT_OSS=$(usex oss ON OFF)
		-DWANT_PERL=$(usex perl ON OFF)
		-DWANT_PHONON=$(usex phonon ON OFF)
		-DWANT_PYTHON=$(usex python ON OFF)
		-DWANT_QTDBUS=$(usex dbus ON OFF)
		-DWANT_QTWEBKIT=$(usex webkit ON OFF)
		-DWANT_SPELLCHECKER=$(usex spell ON OFF)

		# COMPILE_SVG_SUPPORT not used in source code.
		-DWANT_QTSVG=OFF
	)

	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile

	if use doc; then
		cmake-utils_src_compile devdocs
	fi
}

src_install() {
	cmake-utils_src_install

	if use doc; then
		(
			docinto html
			dodoc -r "${BUILD_DIR}/doc/api/html/"*
		)
	fi
}

pkg_postinst() {
	xdg_desktop_database_update
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_desktop_database_update
	xdg_icon_cache_update
}
