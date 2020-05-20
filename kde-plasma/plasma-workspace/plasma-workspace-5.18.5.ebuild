# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

ECM_HANDBOOK="forceoptional"
ECM_TEST="forceoptional"
KFMIN=5.66.0
PVCUT=$(ver_cut 1-3)
QTMIN=5.12.3
VIRTUALX_REQUIRED="test"
inherit ecm kde.org

DESCRIPTION="KDE Plasma workspace"

LICENSE="GPL-2" # TODO: CHECK
SLOT="5"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~x86"
IUSE="appstream +calendar geolocation gps qalculate qrcode +semantic-desktop systemd telemetry"

REQUIRED_USE="gps? ( geolocation )"

# drop qtgui subslot operator when QT_MINIMAL >= 5.14.0
COMMON_DEPEND="
	>=dev-qt/qtdbus-${QTMIN}:5
	>=dev-qt/qtdeclarative-${QTMIN}:5[widgets]
	>=dev-qt/qtgui-${QTMIN}:5=[jpeg]
	>=dev-qt/qtnetwork-${QTMIN}:5
	>=dev-qt/qtsql-${QTMIN}:5
	>=dev-qt/qtwidgets-${QTMIN}:5
	>=dev-qt/qtx11extras-${QTMIN}:5
	>=dev-qt/qtxml-${QTMIN}:5
	>=kde-frameworks/kactivities-${KFMIN}:5
	>=kde-frameworks/kactivities-stats-${KFMIN}:5
	>=kde-frameworks/kauth-${KFMIN}:5
	>=kde-frameworks/kbookmarks-${KFMIN}:5
	>=kde-frameworks/kcompletion-${KFMIN}:5
	>=kde-frameworks/kconfig-${KFMIN}:5
	>=kde-frameworks/kconfigwidgets-${KFMIN}:5
	>=kde-frameworks/kcoreaddons-${KFMIN}:5
	>=kde-frameworks/kcrash-${KFMIN}:5
	>=kde-frameworks/kdbusaddons-${KFMIN}:5
	>=kde-frameworks/kdeclarative-${KFMIN}:5
	>=kde-frameworks/kded-${KFMIN}:5
	>=kde-frameworks/kdelibs4support-${KFMIN}:5
	>=kde-frameworks/kglobalaccel-${KFMIN}:5
	>=kde-frameworks/kguiaddons-${KFMIN}:5
	>=kde-frameworks/ki18n-${KFMIN}:5
	>=kde-frameworks/kiconthemes-${KFMIN}:5
	>=kde-frameworks/kidletime-${KFMIN}:5
	>=kde-frameworks/kio-${KFMIN}:5
	>=kde-frameworks/kitemmodels-${KFMIN}:5
	>=kde-frameworks/kitemviews-${KFMIN}:5
	>=kde-frameworks/kjobwidgets-${KFMIN}:5
	>=kde-frameworks/knewstuff-${KFMIN}:5
	>=kde-frameworks/knotifications-${KFMIN}:5
	>=kde-frameworks/knotifyconfig-${KFMIN}:5
	>=kde-frameworks/kpackage-${KFMIN}:5
	>=kde-frameworks/kpeople-${KFMIN}:5
	>=kde-frameworks/krunner-${KFMIN}:5
	>=kde-frameworks/kservice-${KFMIN}:5
	>=kde-frameworks/ktexteditor-${KFMIN}:5
	>=kde-frameworks/ktextwidgets-${KFMIN}:5
	>=kde-frameworks/kwallet-${KFMIN}:5
	>=kde-frameworks/kwayland-${KFMIN}:5
	>=kde-frameworks/kwidgetsaddons-${KFMIN}:5
	>=kde-frameworks/kwindowsystem-${KFMIN}:5
	>=kde-frameworks/kxmlgui-${KFMIN}:5
	>=kde-frameworks/plasma-${KFMIN}:5
	>=kde-frameworks/solid-${KFMIN}:5
	>=kde-plasma/kscreenlocker-${PVCUT}:5
	>=kde-plasma/kwin-${PVCUT}:5
	>=kde-plasma/libkscreen-${PVCUT}:5
	>=kde-plasma/libksysguard-${PVCUT}:5
	>=kde-plasma/libkworkspace-${PVCUT}:5
	media-libs/phonon[qt5(+)]
	sys-libs/zlib
	x11-libs/libICE
	x11-libs/libSM
	x11-libs/libX11
	x11-libs/libXau
	x11-libs/libxcb
	x11-libs/libXfixes
	x11-libs/libXrender
	x11-libs/libXtst
	x11-libs/xcb-util
	x11-libs/xcb-util-image
	appstream? ( dev-libs/appstream[qt5] )
	calendar? ( >=kde-frameworks/kholidays-${KFMIN}:5 )
	geolocation? ( >=kde-frameworks/networkmanager-qt-${KFMIN}:5 )
	gps? ( sci-geosciences/gpsd )
	qalculate? ( sci-libs/libqalculate:= )
	qrcode? ( >=kde-frameworks/prison-${KFMIN}:5 )
	semantic-desktop? ( >=kde-frameworks/baloo-${KFMIN}:5 )
	telemetry? ( dev-libs/kuserfeedback:5 )
"
DEPEND="${COMMON_DEPEND}
	>=dev-qt/qtconcurrent-${QTMIN}:5
	x11-base/xorg-proto
"
RDEPEND="${COMMON_DEPEND}
	app-text/iso-codes
	>=dev-qt/qdbus-${QTMIN}:5
	>=dev-qt/qtgraphicaleffects-${QTMIN}:5
	>=dev-qt/qtpaths-${QTMIN}:5
	>=dev-qt/qtquickcontrols-${QTMIN}:5[widgets]
	>=dev-qt/qtquickcontrols2-${QTMIN}:5
	>=kde-apps/kio-extras-19.04.3:5
	>=kde-frameworks/kquickcharts-${KFMIN}:5
	>=kde-frameworks/kdesu-${KFMIN}:5
	>=kde-frameworks/kirigami-${KFMIN}:5
	>=kde-plasma/ksysguard-${PVCUT}:5
	>=kde-plasma/milou-${PVCUT}:5
	>=kde-plasma/plasma-integration-${PVCUT}:5
	x11-apps/xmessage
	x11-apps/xprop
	x11-apps/xrdb
	x11-apps/xsetroot
	systemd? ( sys-apps/dbus[user-session] )
	!systemd? ( sys-apps/dbus )
	!<kde-plasma/plasma-desktop-5.16.80:5
"
PDEPEND="
	>=kde-plasma/kde-cli-tools-${PVCUT}:5
"

PATCHES=(
	"${FILESDIR}/${PN}-5.14.2-split-libkworkspace.patch" # downstream patch

	"${FILESDIR}/${P}-sddm-theme-prevent-logo-leaking.patch" # in Plasma/5.18
)

RESTRICT+=" test"

pkg_setup() {
	ecm_pkg_setup

	local md5
	local srcfile=/etc/plasma/XX/10-agent-XX.sh
	local newdir="${EPREFIX}"/etc/xdg/plasma-workspace

	if [[ -f "${EROOT}"${srcfile//XX/startup} ]]; then
		md5=$(md5sum "${EROOT}"${srcfile//XX/startup})
		if [[ ${md5%% *} != 90caaabb40b56bfbe65388841a6dd6ca ]]; then
			elog "Existing modified ${EPREFIX}${srcfile//XX/startup} detected."
			elog "Copying to ${newdir}/env/10-agent-startup.sh..."
			cp -v "${EROOT}"${srcfile//XX/startup} "${T}"/ || die
		fi
	fi

	if [[ -f "${EROOT}"${srcfile//XX/shutdown} ]]; then
		md5=$(md5sum "${EROOT}"${srcfile//XX/shutdown})
		if [[ ${md5%% *} != d7bffa0273f92abd999c7c3c43dbc23d ]]; then
			elog "Existing modified ${EPREFIX}${srcfile//XX/shutdown} detected."
			elog "Copying to ${newdir}/shutdown/10-agent-shutdown.sh..."
			cp -v "${EROOT}"${srcfile//XX/shutdown} "${T}"/ || die
		fi
	fi
}

src_prepare() {
	ecm_src_prepare

	if [[ ! -f "${T}"/10-agent-startup.sh ]]; then
		cp "${FILESDIR}"/10-agent-startup.sh "${T}"/ || die
	fi
	if [[ ! -f "${T}"/10-agent-shutdown.sh ]]; then
		cp "${FILESDIR}"/10-agent-shutdown.sh "${T}"/ || die
	fi

	cmake_comment_add_subdirectory libkworkspace
	# delete colliding libkworkspace translations
	if [[ ${KDE_BUILD_TYPE} = release ]]; then
		find po -type f -name "*po" -and -name "libkworkspace*" -delete || die
	fi
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_xembed-sni-proxy=OFF
		$(cmake_use_find_package appstream AppStreamQt)
		$(cmake_use_find_package calendar KF5Holidays)
		$(cmake_use_find_package geolocation KF5NetworkManagerQt)
		$(cmake_use_find_package qalculate Qalculate)
		$(cmake_use_find_package qrcode KF5Prison)
		$(cmake_use_find_package semantic-desktop KF5Baloo)
		$(cmake_use_find_package telemetry KUserFeedback)
	)

	use geolocation && mycmakeargs+=( $(cmake_use_find_package gps libgps) )

	ecm_src_configure
}

src_install() {
	ecm_src_install

	# default startup and shutdown scripts
	insinto /etc/xdg/plasma-workspace/env
	doins "${T}"/10-agent-startup.sh

	insinto /etc/xdg/plasma-workspace/shutdown
	doins "${T}"/10-agent-shutdown.sh
	fperms +x /etc/xdg/plasma-workspace/shutdown/10-agent-shutdown.sh
}

pkg_postinst () {
	ecm_pkg_postinst

	# Clean up pre-5.17.4 scripts
	if [[ -e "${EROOT}"/etc/plasma/startup/10-agent-startup.sh ]]; then
		rm "${EROOT}"/etc/plasma/startup/10-agent-startup.sh || die
		elog "Removed obsolete ${EPREFIX}/etc/plasma/startup/10-agent-startup.sh"
	fi
	if [[ -e "${EROOT}"/etc/plasma/shutdown/10-agent-shutdown.sh ]]; then
		rm "${EROOT}"/etc/plasma/shutdown/10-agent-shutdown.sh || die
		elog "Removed obsolete ${EPREFIX}/etc/plasma/shutdown/10-agent-shutdown.sh"
	fi

	elog "To enable gpg-agent and/or ssh-agent in Plasma sessions,"
	elog "edit ${EPREFIX}/etc/xdg/plasma-workspace/env/10-agent-startup.sh"
	elog "and ${EPREFIX}/etc/xdg/plasma-workspace/shutdown/10-agent-shutdown.sh"
}
