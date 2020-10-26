# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

KFMIN=5.60.0
QTMIN=5.12.3
inherit ecm kde.org

DESCRIPTION="KPart for rendering Markdown content"
HOMEPAGE="https://apps.kde.org/en/kmarkdownwebviewpart"
SRC_URI="mirror://kde/stable/${PN}/${PV}/src/${P}.tar.xz"

LICENSE="!webkit? ( BSD ) LGPL-2.1+"
SLOT="5"
KEYWORDS="amd64"
IUSE="webkit"

DEPEND="
	>=dev-qt/qtgui-${QTMIN}:5
	>=dev-qt/qtwidgets-${QTMIN}:5
	>=kde-frameworks/kconfigwidgets-${KFMIN}:5
	>=kde-frameworks/kcoreaddons-${KFMIN}:5
	>=kde-frameworks/ki18n-${KFMIN}:5
	>=kde-frameworks/kio-${KFMIN}:5
	>=kde-frameworks/kparts-${KFMIN}:5
	>=kde-frameworks/kxmlgui-${KFMIN}:5
	webkit? ( >=dev-qt/qtwebkit-5.212.0_pre20180120:5 )
	!webkit? (
		>=dev-qt/qtwebchannel-${QTMIN}:5
		>=dev-qt/qtwebengine-${QTMIN}:5[widgets]
	)
"
RDEPEND="${DEPEND}"

src_configure() {
	local mycmakeargs=(
		-DUSE_QTWEBKIT=$(usex webkit)
	)

	ecm_src_configure
}
