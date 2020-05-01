# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

KFMIN=5.69.0
QTMIN=5.12.3
inherit ecm kde.org

DESCRIPTION="SANE Library interface based on KDE Frameworks"

LICENSE="|| ( LGPL-2.1 LGPL-3 )"
SLOT="5"
KEYWORDS="~amd64 ~arm64 ~ppc64"
IUSE="kwallet"

DEPEND="
	>=kde-frameworks/ki18n-${KFMIN}:5
	>=kde-frameworks/ktextwidgets-${KFMIN}:5
	>=kde-frameworks/kwidgetsaddons-${KFMIN}:5
	>=dev-qt/qtgui-${QTMIN}:5
	>=dev-qt/qtwidgets-${QTMIN}:5
	media-gfx/sane-backends
	kwallet? ( >=kde-frameworks/kwallet-${KFMIN}:5 )
"
RDEPEND="${DEPEND}"

src_configure() {
	local mycmakeargs=(
		$(cmake_use_find_package kwallet KF5Wallet)
	)
	ecm_src_configure
}
