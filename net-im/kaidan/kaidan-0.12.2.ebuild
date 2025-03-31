# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_TEST="true"
KFMIN=6.11.0
QTMIN=6.8.0
inherit ecm kde.org xdg

DESCRIPTION="Modern XMPP chat app for every device"
HOMEPAGE="https://www.kaidan.im"

if [[ ${KDE_BUILD_TYPE} == release ]]; then
	SRC_URI="mirror://kde/unstable/${PN}/${PV}/${P}.tar.xz"
	KEYWORDS="~amd64"
fi

LICENSE="CC-BY-SA-4.0 GPL-3+ LGPL-2.1+ MIT"
SLOT="0"

RDEPEND="
	dev-libs/icu:=
	dev-libs/kdsingleapplication
	>=dev-libs/kirigami-addons-1.4.0:6
	>=dev-qt/qtbase-${QTMIN}:6[gui,network,sql,ssl,widgets,xml]
	>=dev-qt/qtdeclarative-${QTMIN}:6
	>=dev-qt/qtlocation-${QTMIN}:6
	>=dev-qt/qtmultimedia-${QTMIN}:6[qml]
	>=dev-qt/qtpositioning-${QTMIN}:6[qml]
	>=dev-qt/qtsvg-${QTMIN}:6
	>=kde-frameworks/kcoreaddons-${KFMIN}:6
	>=kde-frameworks/kcrash-${KFMIN}:6
	>=kde-frameworks/kio-${KFMIN}:6
	>=kde-frameworks/kirigami-${KFMIN}:6
	>=kde-frameworks/knotifications-${KFMIN}:6
	>=kde-frameworks/kwindowsystem-${KFMIN}:6
	>=kde-frameworks/prison-${KFMIN}:6[qml]
	>=kde-frameworks/qqc2-desktop-style-${KFMIN}:6
	media-libs/kquickimageeditor:6
	>=net-libs/qxmpp-1.10.3[omemo]
"
DEPEND="${RDEPEND}
	>=dev-qt/qtbase-${QTMIN}:6[concurrent]
"
BDEPEND=">=dev-qt/qttools-${QTMIN}:6[linguist]"

src_configure() {
	local mycmakeargs=(
		-DUSE_KNOTIFICATIONS=ON
	)
	ecm_src_configure
}
