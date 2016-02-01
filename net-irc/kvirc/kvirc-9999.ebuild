# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"
PYTHON_DEPEND="python? 2"

inherit cmake-utils flag-o-matic multilib python

if [[ "${PV}" == "9999" ]]; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/kvirc/KVIrc"
	KVIRC_GIT_REVISION=""
	KVIRC_GIT_SOURCES_DATE=""
else
	inherit vcs-snapshot

	KVIRC_GIT_REVISION=""
	KVIRC_GIT_SOURCES_DATE="${PV#*_pre}"
	KVIRC_GIT_SOURCES_DATE="$(printf "%04u-%02u-%02u" ${KVIRC_GIT_SOURCES_DATE:0:4} ${KVIRC_GIT_SOURCES_DATE:4:2} ${KVIRC_GIT_SOURCES_DATE:6:2})"
fi

DESCRIPTION="Advanced IRC Client"
HOMEPAGE="http://www.kvirc.net/ https://github.com/kvirc/KVIrc"
if [[ "${PV}" == "9999" ]]; then
	SRC_URI=""
else
	SRC_URI="https://github.com/kvirc/KVIrc/archive/${KVIRC_GIT_REVISION}.tar.gz -> ${P}.tar.gz"
fi

LICENSE="kvirc"
SLOT="0"
KEYWORDS=""
IUSE="audiofile +dbus dcc_video +dcc_voice debug doc gsm +ipc ipv6 kde +nls oss +perl +phonon profile +python spell +ssl theora +transparency webkit"

RDEPEND="dev-qt/qtcore:5
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
	phonon? ( media-libs/phonon:0[qt5] )
	spell? ( app-text/enchant )
	ssl? ( dev-libs/openssl:0= )
	theora? (
		media-libs/libogg
		media-libs/libtheora
		media-libs/libvorbis
	)
	webkit? ( dev-qt/qtwebkit:5 )"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	x11-proto/scrnsaverproto
	doc? ( app-doc/doxygen )
	kde? ( kde-frameworks/extra-cmake-modules:5 )
	nls? ( sys-devel/gettext )"
RDEPEND="${RDEPEND}
	gsm? ( media-sound/gsm )"
REQUIRED_USE="audiofile? ( oss )"

DOCS=(ChangeLog doc/FAQ)

pkg_setup() {
	if use python; then
		python_set_active_version 2
		python_pkg_setup
	fi
}

src_prepare() {
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
		-DWANT_CRYPT=1
		-DWANT_ENV_FLAGS=1
		-DWANT_VERBOSE=1
		$(cmake-utils_use_want audiofile AUDIOFILE)
		$(cmake-utils_use_want dbus QTDBUS)
		$(cmake-utils_use_want dcc_video DCC_VIDEO)
		$(cmake-utils_use_want dcc_voice DCC_VOICE)
		$(cmake-utils_use_want debug DEBUG)
		$(cmake-utils_use_want doc DOXYGEN)
		$(cmake-utils_use_want gsm GSM)
		$(cmake-utils_use_want ipc IPC)
		$(cmake-utils_use_want ipv6 IPV6)
		$(cmake-utils_use_want kde KDE)
		$(cmake-utils_use_want nls GETTEXT)
		$(cmake-utils_use_want oss OSS)
		$(cmake-utils_use_want perl PERL)
		$(cmake-utils_use_want phonon PHONON)
		$(cmake-utils_use_want profile MEMORY_PROFILE)
		$(cmake-utils_use_want python PYTHON)
		$(cmake-utils_use_want spell SPELLCHECKER)
		$(cmake-utils_use_want ssl OPENSSL)
		$(cmake-utils_use_want theora OGG_THEORA)
		$(cmake-utils_use_want transparency TRANSPARENCY)
		$(cmake-utils_use_want webkit QTWEBKIT)

		# COMPILE_SVG_SUPPORT not used in source code.
		-DWANT_QTSVG=OFF
	)

	cmake-utils_src_configure
}
