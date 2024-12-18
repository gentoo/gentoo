# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_HANDBOOK="forceoptional"
KDE_ORG_COMMIT=066e1474850994d00ce03c52194136eebd3ef65d
KFMIN=6.5.0
QTMIN=6.7.2
inherit ecm kde.org optfeature

DESCRIPTION="Advanced twin-panel (commander-style) file-manager with many extras"
HOMEPAGE="https://krusader.org/"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~x86"
IUSE=""

COMMON_DEPEND="
	>=dev-qt/qt5compat-${QTMIN}:6
	>=dev-qt/qtbase-${QTMIN}:6[dbus,gui,widgets,xml]
	>=kde-frameworks/karchive-${KFMIN}:6
	>=kde-frameworks/kbookmarks-${KFMIN}:6
	>=kde-frameworks/kcodecs-${KFMIN}:6
	>=kde-frameworks/kcompletion-${KFMIN}:6
	>=kde-frameworks/kconfig-${KFMIN}:6
	>=kde-frameworks/kconfigwidgets-${KFMIN}:6
	>=kde-frameworks/kcoreaddons-${KFMIN}:6
	>=kde-frameworks/kcrash-${KFMIN}:6
	>=kde-frameworks/kglobalaccel-${KFMIN}:6
	>=kde-frameworks/kguiaddons-${KFMIN}:6
	>=kde-frameworks/ki18n-${KFMIN}:6
	>=kde-frameworks/kiconthemes-${KFMIN}:6
	>=kde-frameworks/kio-${KFMIN}:6
	>=kde-frameworks/kitemviews-${KFMIN}:6
	>=kde-frameworks/kjobwidgets-${KFMIN}:6
	>=kde-frameworks/knotifications-${KFMIN}:6
	>=kde-frameworks/kparts-${KFMIN}:6
	>=kde-frameworks/kservice-${KFMIN}:6
	>=kde-frameworks/kstatusnotifieritem-${KFMIN}:6
	>=kde-frameworks/ktextwidgets-${KFMIN}:6
	>=kde-frameworks/kwallet-${KFMIN}:6
	>=kde-frameworks/kwidgetsaddons-${KFMIN}:6
	>=kde-frameworks/kwindowsystem-${KFMIN}:6
	>=kde-frameworks/kxmlgui-${KFMIN}:6
	>=kde-frameworks/solid-${KFMIN}:6
	sys-apps/acl
	sys-apps/attr
	sys-libs/zlib
"
DEPEND="${COMMON_DEPEND}
	>=dev-qt/qtbase-${QTMIN}:6[concurrent]
"
RDEPEND="${COMMON_DEPEND}
	!${CATEGORY}/${PN}:5
	kde-apps/kio-extras:6
	kde-apps/thumbnailers:6
	>=kde-frameworks/ktexteditor-${KFMIN}:6
	kde-plasma/kdesu-gui:*
"

src_prepare() {
	ecm_src_prepare
	use handbook || cmake_comment_add_subdirectory doc/handbook
}

src_configure() {
	local mycmakeargs=( -DKDESU_PATH=/usr/bin/kdesu )
	ecm_src_configure
}

pkg_postinst() {
	if [[ -z "${REPLACING_VERSIONS}" ]]; then
		optfeature "konsole view" "kde-apps/konsole:6"
		optfeature "Markdown text previews" "kde-misc/markdownpart:6"
		optfeature "Google Drive service" "kde-misc/kio-gdrive:6"
		optfeature "bookmarks support" "kde-apps/keditbookmarks:6"
	fi
	ecm_pkg_postinst
}
