# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"
PYTHON_DEPEND="python? 2"

inherit cmake-utils flag-o-matic multilib python

DESCRIPTION="Advanced IRC Client"
HOMEPAGE="http://www.kvirc.net/"
SRC_URI="http://people.apache.org/~Arfrever/gentoo/${P}.tar.xz"

LICENSE="kvirc"
SLOT="4"
KEYWORDS="~alpha amd64 ~ppc ~ppc64 x86"
IUSE="audiofile +dbus dcc_video +dcc_voice debug doc gsm +ipc ipv6 kde +nls oss +perl +phonon profile +python +ssl theora +transparency webkit"

RDEPEND=">=dev-qt/qtcore-4.6:4
	>=dev-qt/qtgui-4.6:4
	>=dev-qt/qtsql-4.6:4
	sys-libs/zlib
	x11-libs/libX11
	dbus? ( >=dev-qt/qtdbus-4.6:4 )
	dcc_video? (
		media-libs/libv4l
		theora? ( media-libs/libogg media-libs/libtheora )
	)
	kde? ( >=kde-base/kdelibs-4 )
	oss? ( audiofile? ( media-libs/audiofile ) )
	perl? ( dev-lang/perl )
	phonon? ( || ( media-libs/phonon[qt4] >=dev-qt/qtphonon-4.6:4 ) )
	ssl? ( dev-libs/openssl )
	webkit? ( >=dev-qt/qtwebkit-4.6:4 )"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	x11-proto/scrnsaverproto
	nls? ( sys-devel/gettext )
	doc? ( app-doc/doxygen )"
RDEPEND="${RDEPEND}
	gsm? ( media-sound/gsm )"
REQUIRED_USE="audiofile? ( oss ) theora? ( dcc_video )"

DOCS="ChangeLog doc/FAQ"

pkg_setup() {
	if use python; then
		python_set_active_version 2
		python_pkg_setup
	fi
}

src_prepare() {
	VERSIO_PRAESENS="${PV#*_pre}"
	einfo "Setting of revision number to ${VERSIO_PRAESENS}"
	sed -e "/#define KVI_DEFAULT_FRAME_CAPTION/s/KVI_VERSION/& \" r${VERSIO_PRAESENS}\"/" -i src/kvirc/ui/KviMainWindow.cpp || die "Setting of revision number failed"
}

src_configure() {
	append-flags -fno-strict-aliasing

	if use dcc_video && has_version ">=sys-kernel/linux-headers-3.9"; then
		append-cppflags -DV4L2_CID_HCENTER="\\\"(V4L2_CID_BASE+22)\\\"" -DV4L2_CID_VCENTER="\\\"(V4L2_CID_BASE+23)\\\""
	fi

	local libdir="$(get_libdir)"
	local mycmakeargs=(
		-DLIB_SUFFIX=${libdir#lib}
		-DMANUAL_REVISION=${VERSIO_PRAESENS}
		-DWANT_COEXISTENCE=1
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
		$(cmake-utils_use_want kde KDE4)
		$(cmake-utils_use_want nls GETTEXT)
		$(cmake-utils_use_want oss OSS)
		$(cmake-utils_use_want perl PERL)
		$(cmake-utils_use_want phonon PHONON)
		$(cmake-utils_use_want profile MEMORY_PROFILE)
		$(cmake-utils_use_want python PYTHON)
		$(cmake-utils_use_want ssl OPENSSL)
		$(cmake-utils_use_want theora OGG_THEORA)
		$(cmake-utils_use_want transparency TRANSPARENCY)
		$(cmake-utils_use_want webkit QTWEBKIT)
	)

	cmake-utils_src_configure
}
