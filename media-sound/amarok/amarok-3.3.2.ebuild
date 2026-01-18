# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_HANDBOOK="forceoptional"
KFMIN=6.9.0
QTMIN=6.7.2
PYTHON_COMPAT=( python3_{11..13} )
inherit ecm kde.org optfeature python-any-r1 xdg

if [[ ${KDE_BUILD_TYPE} == release ]]; then
	SRC_URI="mirror://kde/stable/${PN}/${PV}/${P}.tar.xz"
	KEYWORDS="~amd64 ~arm64"
fi

DESCRIPTION="Advanced audio player based on KDE Frameworks"
HOMEPAGE="https://amarok.kde.org/"

LICENSE="GPL-2"
SLOT="0"
IUSE="ipod lastfm mariadb mtp podcast webengine X"

# ipod requires gdk enabled and also gtk compiled in libgpod
DEPEND="
	dev-libs/glib:2
	>=dev-qt/qtbase-${QTMIN}:6[dbus,gui,network,sql,widgets,xml]
	>=dev-qt/qtdeclarative-${QTMIN}:6
	>=dev-qt/qtsvg-${QTMIN}:6
	>=dev-qt/qttools-${QTMIN}:6[designer]
	>=kde-frameworks/attica-${KFMIN}:6
	>=kde-frameworks/karchive-${KFMIN}:6
	>=kde-frameworks/kcmutils-${KFMIN}:6
	>=kde-frameworks/kcodecs-${KFMIN}:6
	>=kde-frameworks/kcolorscheme-${KFMIN}:6
	>=kde-frameworks/kcompletion-${KFMIN}:6
	>=kde-frameworks/kconfig-${KFMIN}:6
	>=kde-frameworks/kconfigwidgets-${KFMIN}:6
	>=kde-frameworks/kcoreaddons-${KFMIN}:6
	>=kde-frameworks/kcrash-${KFMIN}:6
	>=kde-frameworks/kdbusaddons-${KFMIN}:6
	>=kde-frameworks/kdeclarative-${KFMIN}:6
	>=kde-frameworks/kdnssd-${KFMIN}:6
	>=kde-frameworks/kglobalaccel-${KFMIN}:6
	>=kde-frameworks/kguiaddons-${KFMIN}:6
	>=kde-frameworks/ki18n-${KFMIN}:6
	>=kde-frameworks/kiconthemes-${KFMIN}:6
	>=kde-frameworks/kio-${KFMIN}:6
	>=kde-frameworks/kitemviews-${KFMIN}:6
	>=kde-frameworks/knewstuff-${KFMIN}:6
	>=kde-frameworks/knotifications-${KFMIN}:6
	>=kde-frameworks/kpackage-${KFMIN}:6
	>=kde-frameworks/kservice-${KFMIN}:6
	>=kde-frameworks/kstatusnotifieritem-${KFMIN}:6
	>=kde-frameworks/ktexteditor-${KFMIN}:6
	>=kde-frameworks/ktextwidgets-${KFMIN}:6
	>=kde-frameworks/kwidgetsaddons-${KFMIN}:6
	>=kde-frameworks/kwindowsystem-${KFMIN}:6[X?]
	>=kde-frameworks/kxmlgui-${KFMIN}:6
	>=kde-frameworks/solid-${KFMIN}:6
	>=kde-frameworks/threadweaver-${KFMIN}:6
	media-libs/gstreamer:1.0
	media-libs/gst-plugins-base:1.0
	>=media-libs/taglib-1.12:=
	sci-libs/fftw:3.0
	virtual/opengl
	virtual/zlib:=
	ipod? (
		media-libs/libgpod[gtk]
		x11-libs/gdk-pixbuf:2
	)
	lastfm? ( >=media-libs/liblastfm-1.1.0_pre20241124 )
	mariadb? ( dev-db/mariadb-connector-c:= )
	!mariadb? ( dev-db/mysql-connector-c:= )
	mtp? ( media-libs/libmtp )
	podcast? ( >=media-libs/libmygpo-qt-1.1.0_pre20240811 )
	webengine? ( >=dev-qt/qtwebengine-${QTMIN}:6[widgets] )
"
RDEPEND="${DEPEND}
	>=kde-frameworks/kirigami-${KFMIN}:6
	media-plugins/gst-plugins-meta:1.0
	media-video/ffmpeg
"
BDEPEND="${PYTHON_DEPS}
	>=dev-qt/qttools-${QTMIN}:6[linguist]
	virtual/pkgconfig
"

src_configure() {
	local mycmakeargs=(
		-DWITH_EMBEDDED_DB=OFF
		-DWITH_MP3Tunes=OFF
		-DWITH_PLAYER=ON
		-DWITH_UTILITIES=ON
		-DCMAKE_DISABLE_FIND_PACKAGE_Googlemock=ON
		-DWITH_IPOD=$(usex ipod)
		$(cmake_use_find_package lastfm LibLastFm)
		$(cmake_use_find_package !mariadb MySQL)
		$(cmake_use_find_package mtp Mtp)
		$(cmake_use_find_package podcast Mygpo-qt6)
		$(cmake_use_find_package webengine Qt6WebEngineWidgets)
		-DWITH_X11=$(usex X)
	)
	use ipod && mycmakeargs+=( $(cmake_use_find_package ipod GDKPixBuf) )

	ecm_src_configure
}

pkg_postinst() {
	xdg_pkg_postinst

	pkg_is_installed() {
		echo "${1} ($(has_version ${1} || echo "not ")installed)"
	}

	db_name() {
		use mariadb && echo "MariaDB" || echo "MySQL"
	}

	optfeature "Audio CD support" "kde-apps/audiocd-kio:6"

	if [[ -z ${REPLACING_VERSIONS} ]]; then
		elog "You must configure ${PN} to use an external database server."
		elog " 1. Make sure either MySQL or MariaDB is installed and configured"
		elog "    Checking local system:"
		elog "      $(pkg_is_installed dev-db/mariadb)"
		elog "      $(pkg_is_installed dev-db/mysql)"
		elog "    For preliminary configuration of $(db_name) Server refer to"
		elog "    https://wiki.gentoo.org/wiki/$(db_name)#Configuration"
		elog " 2. Ensure 'mysql' service is started and run:"
		elog "    # emerge --config amarok"
		elog " 3. Run ${PN} and go to 'Configure Amarok - Database' menu page"
		elog "    Check 'Use external MySQL database' and press OK"
		elog
		elog "For more information please read:"
		elog "  https://community.kde.org/Amarok/Community/MySQL"
	fi
}

pkg_config() {
	# Create external mysql database with amarok default user/password
	local AMAROK_DB_NAME="amarokdb"
	local AMAROK_DB_USER_NAME="amarokuser"
	local AMAROK_DB_USER_PWD="password"

	einfo "Initializing ${PN} MySQL database 'amarokdb':"
	einfo "If prompted for a password, please enter your MySQL root password."
	einfo

	if [[ -e "${EROOT}"/usr/bin/mysql ]]; then
		"${EROOT}"/usr/bin/mysql -u root -p -e "CREATE DATABASE IF NOT EXISTS ${AMAROK_DB_NAME}; GRANT ALL PRIVILEGES ON ${AMAROK_DB_NAME}.* TO '${AMAROK_DB_USER_NAME}' IDENTIFIED BY '${AMAROK_DB_USER_PWD}'; FLUSH PRIVILEGES;"
	fi
	einfo "${PN} MySQL database 'amarokdb' successfully initialized!"
}
