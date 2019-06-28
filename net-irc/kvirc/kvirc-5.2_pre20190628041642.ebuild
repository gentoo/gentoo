# Copyright 2009-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# True Authors: Arfrever Frehtes Taifersar Arahesis

EAPI="7"
PYTHON_COMPAT=(python2_7)

inherit cmake-utils flag-o-matic python-single-r1 xdg-utils

if [[ "${PV}" == "9999" ]]; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/kvirc/KVIrc"
	KVIRC_GIT_REVISION=""
	KVIRC_GIT_SOURCES_DATE=""
else
	KVIRC_GIT_REVISION="2fe1a3bcac42349967e27b3f7098c25f34efca1d"
	KVIRC_GIT_SOURCES_DATE="${PV#*_pre}"
	KVIRC_GIT_SOURCES_DATE="${KVIRC_GIT_SOURCES_DATE:0:4}-${KVIRC_GIT_SOURCES_DATE:4:2}-${KVIRC_GIT_SOURCES_DATE:6:2}"
fi

DESCRIPTION="Advanced IRC Client"
HOMEPAGE="http://www.kvirc.net/ https://github.com/kvirc/KVIrc"
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

BDEPEND="virtual/pkgconfig
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
		-DWANT_ENV_FLAGS=yes
		-DWANT_VERBOSE=yes

		-DWANT_CRYPT=yes
		-DWANT_DCC_VOICE=yes
		-DWANT_IPC=yes
		-DWANT_IPV6=yes
		-DWANT_TRANSPARENCY=yes

		-DWANT_AUDIOFILE=$(usex audiofile)
		-DWANT_DCC_VIDEO=$(usex dcc_video)
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
		-DWANT_QTWEBKIT=$(usex webkit)
		-DWANT_SPELLCHECKER=$(usex spell)

		# COMPILE_SVG_SUPPORT not used in source code.
		-DWANT_QTSVG=no
	)

	cmake-utils_src_configure
}

pkg_postinst() {
	xdg_desktop_database_update
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_desktop_database_update
	xdg_icon_cache_update
}
