# Copyright 2021-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit qt6-build

DESCRIPTION="Cross-platform application development framework"

if [[ ${QT6_BUILD_TYPE} == release ]]; then
	KEYWORDS="~amd64"
fi

# Qt Modules
IUSE="+concurrent +dbus +gui +network +sql opengl +widgets +xml zstd"
REQUIRED_USE="
	opengl? ( gui )
	widgets? ( gui )
	X? ( || ( evdev libinput ) )
"

QTGUI_IUSE="accessibility egl eglfs evdev gles2-only +jpeg +libinput tslib tuio vulkan +X"
QTNETWORK_IUSE="brotli gssapi libproxy sctp +ssl vnc"
QTSQL_IUSE="freetds mysql oci8 odbc postgres +sqlite"
IUSE+=" ${QTGUI_IUSE} ${QTNETWORK_IUSE} ${QTSQL_IUSE} cups gtk icu systemd +udev"
# QtPrintSupport = QtGui + QtWidgets enabled.
# ibus = xkbcommon + dbus, and xkbcommon needs either libinput or X
REQUIRED_USE+="
	$(printf '%s? ( gui ) ' ${QTGUI_IUSE//+/})
	$(printf '%s? ( network ) ' ${QTNETWORK_IUSE//+/})
	$(printf '%s? ( sql ) ' ${QTSQL_IUSE//+/})
	accessibility? ( dbus X )
	cups? ( gui widgets )
	eglfs? ( egl )
	gtk? ( widgets )
	gui? ( || ( eglfs X ) || ( libinput X ) )
	libinput? ( udev )
	sql? ( || ( freetds mysql oci8 odbc postgres sqlite ) )
	vnc? ( gui )
	X? ( gles2-only? ( egl ) )
"

# TODO:
# qtimageformats: mng not done yet, qtimageformats.git upstream commit 9443239c
# qtnetwork: connman, networkmanager
DEPEND="
	app-crypt/libb2
	dev-libs/double-conversion:=
	dev-libs/glib:2
	dev-libs/libpcre2:=[pcre16,unicode]
	dev-util/gtk-update-icon-cache
	media-libs/fontconfig
	>=media-libs/freetype-2.6.1:2
	>=media-libs/harfbuzz-1.6.0:=
	media-libs/tiff:=
	>=sys-apps/dbus-1.4.20
	sys-libs/zlib:=
	brotli? ( app-arch/brotli:= )
	evdev? ( sys-libs/mtdev )
	freetds? ( dev-db/freetds )
	gles2-only? ( media-libs/libglvnd )
	!gles2-only? ( media-libs/libglvnd[X] )
	gssapi? ( virtual/krb5 )
	gtk? (
		x11-libs/gtk+:3
		x11-libs/libX11
		x11-libs/pango
	)
	gui? ( media-libs/libpng:= )
	icu? ( dev-libs/icu:= )
	!icu? ( virtual/libiconv )
	jpeg? ( media-libs/libjpeg-turbo:= )
	libinput? (
		dev-libs/libinput:=
		>=x11-libs/libxkbcommon-0.5.0
	)
	libproxy? ( net-libs/libproxy )
	mysql? ( dev-db/mysql-connector-c:= )
	oci8? ( dev-db/oracle-instantclient:=[sdk] )
	odbc? ( dev-db/unixODBC )
	postgres? ( dev-db/postgresql:* )
	sctp? ( kernel_linux? ( net-misc/lksctp-tools ) )
	sqlite? ( dev-db/sqlite:3 )
	ssl? ( dev-libs/openssl:= )
	systemd? ( sys-apps/systemd:= )
	tslib? ( >=x11-libs/tslib-1.21 )
	udev? ( virtual/libudev:= )
	vulkan? ( dev-util/vulkan-headers )
	X? (
		x11-libs/libdrm
		x11-libs/libICE
		x11-libs/libSM
		x11-libs/libX11
		>=x11-libs/libxcb-1.12:=
		>=x11-libs/libxkbcommon-0.5.0[X]
		x11-libs/xcb-util-image
		x11-libs/xcb-util-keysyms
		x11-libs/xcb-util-renderutil
		x11-libs/xcb-util-wm
	)
	zstd? ( app-arch/zstd:= )
"
RDEPEND="${DEPEND}"

src_configure() {
	local mycmakeargs=(
		-DINSTALL_ARCHDATADIR=${QT6_ARCHDATADIR}
		-DINSTALL_BINDIR=${QT6_BINDIR}
		-DINSTALL_DATADIR=${QT6_DATADIR}
		-DINSTALL_DOCDIR=${QT6_DOCDIR}
		-DINSTALL_EXAMPLESDIR=${QT6_EXAMPLESDIR}
		-DINSTALL_INCLUDEDIR=${QT6_HEADERDIR}
		-DINSTALL_LIBDIR=${QT6_LIBDIR}
		-DINSTALL_LIBEXECDIR=${QT6_LIBEXECDIR}
		-DINSTALL_MKSPECSDIR=${QT6_ARCHDATADIR}/mkspecs
		-DINSTALL_PLUGINSDIR=${QT6_PLUGINDIR}
		-DINSTALL_QMLDIR=${QT6_QMLDIR}
		-DINSTALL_SYSCONFDIR=${QT6_SYSCONFDIR}
		-DINSTALL_TRANSLATIONSDIR=${QT6_TRANSLATIONDIR}
		-DQT_FEATURE_androiddeployqt=OFF
		$(qt_feature concurrent)
		$(qt_feature dbus)
		$(qt_feature gui)
		$(qt_feature gui testlib)
		$(qt_feature icu)
		$(qt_feature network)
		$(qt_feature sql)
		$(qt_feature systemd journald)
		$(qt_feature udev libudev)
		$(qt_feature xml)
		$(qt_feature zstd)
	)
	use gui && mycmakeargs+=(
		$(qt_feature accessibility accessibility_atspi_bridge)
		$(qt_feature egl)
		$(qt_feature eglfs eglfs_egldevice)
		$(qt_feature eglfs eglfs_gbm)
		$(qt_feature evdev)
		$(qt_feature evdev mtdev)
		-DQT_FEATURE_gif=ON
		$(qt_feature jpeg)
		$(qt_feature opengl)
		$(qt_feature gles2-only opengles2)
		$(qt_feature libinput)
		$(qt_feature tslib)
		$(qt_feature tuio tuiotouch)
		$(qt_feature vulkan)
		$(qt_feature widgets)
		$(qt_feature X xcb)
		$(qt_feature X xcb_xlib)
	)
	use widgets && mycmakeargs+=(
		$(qt_feature cups)
		$(qt_feature gtk gtk3)
	)
	if use libinput || use X; then
		mycmakeargs+=( -DQT_FEATURE_xkbcommon=ON )
	fi
	use network && mycmakeargs+=(
		$(qt_feature brotli)
		$(qt_feature gssapi)
		$(qt_feature libproxy)
		$(qt_feature sctp)
		$(qt_feature ssl openssl)
		$(qt_feature vnc)
	)
	use sql && mycmakeargs+=(
		$(qt_feature freetds sql_tds)
		$(qt_feature mysql sql_mysql)
		$(qt_feature oci8 sql_oci)
		$(qt_feature odbc sql_odbc)
		$(qt_feature postgres sql_psql)
		$(qt_feature sqlite sql_sqlite)
		$(qt_feature sqlite system_sqlite)
	)

	qt6-build_src_configure
}

src_install() {
	qt6-build_src_install

	# https://bugs.gentoo.org/863395
	qt6_symlink_binary_to_path qmake 6
}
