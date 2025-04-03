# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake xdg

DESCRIPTION="GPS mapping utility"
HOMEPAGE="https://github.com/Maproom/qmapshack/wiki"
MY_PV="$(ver_cut 1-3)"
SRC_URI="https://github.com/Maproom/${PN}/archive/V_${MY_PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-V_${MY_PV}"
LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64"
IUSE="dbus"

RDEPEND="
	dev-db/sqlite
	>=dev-libs/quazip-1.3:0=[qt6]
	dev-qt/qt5compat:6
	dev-qt/qtbase:6[dbus,gui,network,sql,widgets,xml]
	dev-qt/qtdeclarative:6
	dev-qt/qttools:6[assistant,widgets]
	dev-qt/qtwebengine:6[widgets]
	sci-geosciences/routino
	sci-libs/alglib
	sci-libs/gdal:=
	sci-libs/proj:=
"
DEPEND="${RDEPEND}"
BDEPEND="dev-qt/qttools:6[linguist]"

# commit 026aaea93a3dbd8eaa398d4eb74436f58a4a6894
# git format-patch -o sci-geosciences/qmapshack/files/qmapshack-1.17.1_p20250403/ V_1.17.1
PATCHES=(
	"${FILESDIR}"/"${P}"/0001-QMS-654-MacOS-build-changes-to-build-scripts.patch
	"${FILESDIR}"/"${P}"/0002-QMS-656-TMS-WMTS-Fix-loosing-layer-selection-when-re.patch
	"${FILESDIR}"/"${P}"/0003-QMS-668-MacOS-build-adapted-to-new-gdal-version-and-.patch
	"${FILESDIR}"/"${P}"/0004-QMS-675-The-label-colors-defined-in-the-TYP-are-not-.patch
	"${FILESDIR}"/"${P}"/0005-QMS-675-Apply-font-size-and-color-to-polylines.patch
	"${FILESDIR}"/"${P}"/0006-QMS-683-Fix-alglib-error-on-interpolation.patch
	"${FILESDIR}"/"${P}"/0007-QMS-680-Fix-Sending-multiple-selected-projects-to-de.patch
	"${FILESDIR}"/"${P}"/0008-QMS-692-Trackpoints-erroneously-flaged-invalid-for-s.patch
	"${FILESDIR}"/"${P}"/0009-use-SETTINGS-instead-of-QSetting-cfg.patch
	"${FILESDIR}"/"${P}"/0010-changelog.patch
	"${FILESDIR}"/"${P}"/0011-QMS-706-Apply-PNG-offset-to-user-defined-waypoints.patch
	"${FILESDIR}"/"${P}"/0012-Update-changelog.txt.patch
	"${FILESDIR}"/"${P}"/0013-Adjust-square-zoom-levels-to-fit-EPSG-3857-tiles-and.patch
	"${FILESDIR}"/"${P}"/0014-Replace-QRegExp-by-QRegularExpression.patch
	"${FILESDIR}"/"${P}"/0015-Replace-qAsConst-by-std-as_const.patch
	"${FILESDIR}"/"${P}"/0016-Replace-toTime_T-by-toSecsSinceEpoch.patch
	"${FILESDIR}"/"${P}"/0017-Replace-QMatrix-by-QTransform.patch
	"${FILESDIR}"/"${P}"/0018-Fix-QFontMetric-width.patch
	"${FILESDIR}"/"${P}"/0019-Fix-code-for-Qt6.patch
	"${FILESDIR}"/"${P}"/0020-Qt6-adjustments-for-Windows-version.patch
	"${FILESDIR}"/"${P}"/0021-Qt6DBus-support.patch
	"${FILESDIR}"/"${P}"/0022-QMS-694-Porting-Qt6-Fix-decoding-of-device-mount-poi.patch
	"${FILESDIR}"/"${P}"/0023-QMS-697-Fix-QByteArray-to-QString-decoding.patch
	"${FILESDIR}"/"${P}"/0024-prevent-BorderCollapsing.patch
	"${FILESDIR}"/"${P}"/0025-Qt6-bring-back-xdg-desktop-files.patch
	"${FILESDIR}"/"${P}"/0026-cmake-remove-now-unused-module-TranslateDesktop.patch
)

src_configure() {
	local mycmakeargs=( -DUSE_QT6DBus=$(usex dbus) )
	cmake_src_configure
}

src_install() {
	docompress -x /usr/share/doc/${PF}/html
	cmake_src_install
	mv "${D}"/usr/share/doc/HTML "${D}"/usr/share/doc/${PF}/html || die "mv Qt help failed"
	ewarn "An experimental Qt6 port"
	ewarn "Translations and the help system are broken"
	ewarn "Other bugs to https://github.com/Maproom/qmapshack/issues"
}
