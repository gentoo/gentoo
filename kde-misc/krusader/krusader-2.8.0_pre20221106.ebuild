# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

KDE_ORG_COMMIT="10d5ec93f0c68ac68240c7c1fb98ba993499beb7"
ECM_HANDBOOK="forceoptional"
KFMIN=5.82.0
QTMIN=5.15.5
inherit ecm kde.org optfeature

# if [[ ${KDE_BUILD_TYPE} = release ]]; then
# 	KEYWORDS="~amd64 ~arm64 ~ppc64 ~x86"
# fi

DESCRIPTION="Advanced twin-panel (commander-style) file-manager with many extras"
HOMEPAGE="https://krusader.org/"

LICENSE="GPL-2+"
SLOT="5"
IUSE=""

COMMON_DEPEND="
	>=dev-qt/qtdbus-${QTMIN}:5
	>=dev-qt/qtgui-${QTMIN}:5
	>=dev-qt/qtprintsupport-${QTMIN}:5
	>=dev-qt/qtwidgets-${QTMIN}:5
	>=dev-qt/qtxml-${QTMIN}:5
	>=kde-frameworks/karchive-${KFMIN}:5
	>=kde-frameworks/kbookmarks-${KFMIN}:5
	>=kde-frameworks/kcodecs-${KFMIN}:5
	>=kde-frameworks/kcompletion-${KFMIN}:5
	>=kde-frameworks/kconfig-${KFMIN}:5
	>=kde-frameworks/kconfigwidgets-${KFMIN}:5
	>=kde-frameworks/kcoreaddons-${KFMIN}:5
	>=kde-frameworks/kguiaddons-${KFMIN}:5
	>=kde-frameworks/ki18n-${KFMIN}:5
	>=kde-frameworks/kiconthemes-${KFMIN}:5
	>=kde-frameworks/kio-${KFMIN}:5
	>=kde-frameworks/kitemviews-${KFMIN}:5
	>=kde-frameworks/kjobwidgets-${KFMIN}:5
	>=kde-frameworks/knotifications-${KFMIN}:5
	>=kde-frameworks/kparts-${KFMIN}:5
	>=kde-frameworks/kservice-${KFMIN}:5
	>=kde-frameworks/ktextwidgets-${KFMIN}:5
	>=kde-frameworks/kwallet-${KFMIN}:5
	>=kde-frameworks/kwidgetsaddons-${KFMIN}:5
	>=kde-frameworks/kwindowsystem-${KFMIN}:5
	>=kde-frameworks/kxmlgui-${KFMIN}:5
	>=kde-frameworks/solid-${KFMIN}:5
	sys-apps/acl
	sys-libs/zlib
"
DEPEND="${COMMON_DEPEND}
	>=dev-qt/qtconcurrent-${QTMIN}:5
"
RDEPEND="${COMMON_DEPEND}
	kde-apps/kio-extras:5
"

pkg_postinst() {
	if [[ -z "${REPLACING_VERSIONS}" ]]; then
		optfeature "Markdown text previews" "kde-misc/markdownpart:${SLOT}"
		optfeature "PDF/PS and RAW image thumbnails" "kde-apps/thumbnailers:${SLOT}"
		optfeature "video thumbnails" "kde-apps/ffmpegthumbs:${SLOT}"
		optfeature "bookmarks support" "kde-apps/keditbookmarks:${SLOT}"
	fi
	ecm_pkg_postinst
}
