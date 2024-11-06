# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

KDE_ORG_CATEGORY="office"
ECM_HANDBOOK="optional"
KFMIN=6.5.0
QTMIN=6.7.2
inherit ecm gear.kde.org

DESCRIPTION="Cross-platform, aesthetic, distraction-free markdown editor"
HOMEPAGE="https://ghostwriter.kde.org/"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~arm64"
IUSE=""

RDEPEND="
	app-text/hunspell:=
	>=dev-qt/qtbase-${QTMIN}:6[gui,widgets]
	>=dev-qt/qtsvg-${QTMIN}:6
	>=dev-qt/qtwebchannel-${QTMIN}:6
	>=dev-qt/qtwebengine-${QTMIN}:6
	>=kde-frameworks/kcoreaddons-${KFMIN}:6
	>=kde-frameworks/kwidgetsaddons-${KFMIN}:6
	>=kde-frameworks/kxmlgui-${KFMIN}:6
	>=kde-frameworks/sonnet-${KFMIN}:6
	virtual/opengl
"
DEPEND="${RDEPEND}
	>=dev-qt/qtbase-${QTMIN}:6[concurrent]
"
BDEPEND="
	>=dev-qt/qttools-${QTMIN}:6[linguist]
	virtual/pkgconfig
"

DOCS=( CHANGELOG.md README.md )

# Picked for 24.08.3, hopefully to be respun:
# https://invent.kde.org/office/ghostwriter/-/merge_requests/46
PATCHES=( "${FILESDIR}/${P}-fix-segfault.patch" ) # bug 942928
