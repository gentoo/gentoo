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
"

QTGUI_IUSE="accessibility egl eglfs evdev gles2-only +jpeg +libinput tslib tuio vulkan +X"
QTNETWORK_IUSE="brotli gssapi libproxy sctp +ssl vnc"
QTSQL_IUSE="freetds mysql oci8 odbc postgres +sqlite"
IUSE+=" ${QTGUI_IUSE} ${QTNETWORK_IUSE} ${QTSQL_IUSE} cups gtk icu systemd +udev wayland"
# QtPrintSupport = QtGui + QtWidgets enabled.
# ibus = xkbcommon + dbus, and xkbcommon needs either X or libinput
REQUIRED_USE+="
	$(
		printf '%s? ( gui ) ' ${QTGUI_IUSE//+/}
		printf '%s? ( network ) ' ${QTNETWORK_IUSE//+/}
		printf '%s? ( sql ) ' ${QTSQL_IUSE//+/}
	)
	X? (
		|| ( evdev libinput )
		gles2-only? ( egl )
	)
	accessibility? ( X dbus )
	cups? ( gui widgets )
	eglfs? ( egl )
	gtk? ( widgets )
	gui? ( || ( X eglfs ) || ( X libinput ) )
	libinput? ( udev )
	sql? ( || ( freetds mysql oci8 odbc postgres sqlite ) )
	test? (
		gui jpeg icu
		sql? ( sqlite )
	)
	vnc? ( gui )
"

# TODO:
# qtimageformats: mng not done yet, qtimageformats.git upstream commit 9443239c
# qtnetwork: connman, networkmanager
RDEPEND="
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
	X? (
		x11-libs/libdrm
		x11-libs/libICE
		x11-libs/libSM
		x11-libs/libX11
		>=x11-libs/libxcb-1.12:=
		>=x11-libs/libxkbcommon-0.5.0[X]
		x11-libs/xcb-util-cursor
		x11-libs/xcb-util-image
		x11-libs/xcb-util-keysyms
		x11-libs/xcb-util-renderutil
		x11-libs/xcb-util-wm
	)
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
	zstd? ( app-arch/zstd:= )
"
DEPEND="${RDEPEND}"
PDEPEND="wayland? ( =dev-qt/qtwayland-${PV}*:6 )" #864509

src_prepare() {
	qt6-build_src_prepare

	if use test; then
		# test itself has -Werror=strict-aliasing issues, drop for simplicity
		sed -e '/add_subdirectory(qsharedpointer)/d' \
			-i tests/auto/corelib/tools/CMakeLists.txt || die
	fi
}

src_configure() {
	local mycmakeargs=(
		-DINSTALL_ARCHDATADIR="${QT6_ARCHDATADIR}"
		-DINSTALL_BINDIR="${QT6_BINDIR}"
		-DINSTALL_DATADIR="${QT6_DATADIR}"
		-DINSTALL_DOCDIR="${QT6_DOCDIR}"
		-DINSTALL_EXAMPLESDIR="${QT6_EXAMPLESDIR}"
		-DINSTALL_INCLUDEDIR="${QT6_HEADERDIR}"
		-DINSTALL_LIBDIR="${QT6_LIBDIR}"
		-DINSTALL_LIBEXECDIR="${QT6_LIBEXECDIR}"
		-DINSTALL_MKSPECSDIR="${QT6_MKSPECSDIR}"
		-DINSTALL_PLUGINSDIR="${QT6_PLUGINDIR}"
		-DINSTALL_QMLDIR="${QT6_QMLDIR}"
		-DINSTALL_SYSCONFDIR="${QT6_SYSCONFDIR}"
		-DINSTALL_TRANSLATIONSDIR="${QT6_TRANSLATIONDIR}"
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
		$(qt_feature X xcb)
		$(qt_feature X xcb_xlib)
		$(qt_feature accessibility accessibility_atspi_bridge)
		$(qt_feature egl)
		$(qt_feature egl xcb_egl_plugin)
		$(qt_feature eglfs eglfs_egldevice)
		$(qt_feature eglfs eglfs_gbm)
		$(qt_feature evdev)
		$(qt_feature evdev mtdev)
		-DQT_FEATURE_gif=ON
		$(qt_feature gles2-only opengles2)
		$(qt_feature jpeg)
		$(qt_feature libinput)
		$(qt_feature opengl)
		$(qt_feature tslib)
		$(qt_feature tuio tuiotouch)
		$(qt_feature vulkan)
		$(qt_feature widgets)
	)
	use widgets && mycmakeargs+=(
		$(qt_feature cups)
		$(qt_feature gtk gtk3)
	)
	if use X || use libinput; then
		mycmakeargs+=( -DQT_FEATURE_xkbcommon=ON )
	fi
	use network && mycmakeargs+=(
		$(qt_feature brotli)
		$(qt_feature gssapi)
		$(qt_feature libproxy)
		$(qt_feature sctp)
		$(qt_feature ssl openssl)
		$(qt_feature vnc)
		$(usev test -DQT_SKIP_DOCKER_COMPOSE=ON)
	)
	use sql && mycmakeargs+=(
		$(qt_feature freetds sql_tds)
		$(qt_feature mysql sql_mysql)
		$(qt_feature oci8 sql_oci)
		$(usev oci8 -DOracle_ROOT="${ESYSROOT}"/usr/$(get_libdir)/oracle/client)
		$(qt_feature odbc sql_odbc)
		$(qt_feature postgres sql_psql)
		$(qt_feature sqlite sql_sqlite)
		$(qt_feature sqlite system_sqlite)
	)

	qt6-build_src_configure
}

src_test() {
	local -x TZ=UTC
	local -x LC_TIME=C

	local CMAKE_SKIP_TESTS=(
		# broken with out-of-source + if qtbase is not already installed
		tst_moc
		tst_qmake
		# needs x11/opengl, we *could* run these but tend to be flaky
		# when opengl rendering is involved (even if software-only)
		tst_qopengl{,config,widget,window}
		tst_qgraphicsview
		tst_qx11info
		# fails with network sandbox
		tst_qdnslookup
		# typical to lack SCTP support on non-generic kernels
		tst_qsctpsocket
		# these can be flaky depending on the environment/toolchain
		tst_qlogging # backtrace log test can easily vary
		tst_qrawfont # can be affected by available fonts
		tst_qstorageinfo # checks mounted filesystems
		# flaky due to using different test framework and fails with USE=-gui
		tst_selftests
		# known failing when using clang+glibc+stdc++, needs looking into
		tst_qthread
		# partially failing on x86 chroots and seemingly(?) harmless (dev-qt
		# revdeps tests pass), skip globally to avoid keywording flakiness
		tst_json
		tst_qcolorspace
		tst_qdoublevalidator
		tst_qglobal
		tst_qglyphrun
		tst_qvectornd
		tst_rcc
		# note: for linux, upstream only really runs+maintains tests for amd64
		# https://doc.qt.io/qt-6/supported-platforms.html
	)

	qt6-build_src_test
}

src_install() {
	qt6-build_src_install

	qt6_symlink_binary_to_path qmake 6 #863395

	if use test; then
		local delete_bins=( # need a better way to handle this
			clientserver copier crashingServer desktopsettingsaware_helper
			echo fileWriterProcess modal_helper nospace 'one space'
			paster qcommandlineparser_test_helper qfileopeneventexternal
			socketprocess syslocaleapp tst_qhashseed_helper 'two space s'
			write-read-write
		)
		local delete=( # sigh
			"${D}${QT6_BINDIR}"/test*
			"${delete_bins[@]/#/${D}${QT6_BINDIR}/}"
		)
		# using -f given not tracking which tests may be skipped or not
		rm -rf -- "${delete[@]}" || die
	fi
}
