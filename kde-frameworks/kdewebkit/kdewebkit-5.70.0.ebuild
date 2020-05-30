# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

ECM_QTHELP="false"
ECM_TEST="false"
PVCUT=$(ver_cut 1-2)
QTMIN=5.12.3
inherit ecm kde.org

DESCRIPTION="Framework providing KDE integration of QtWebKit"
LICENSE="LGPL-2+"
KEYWORDS="amd64 ~arm ~arm64 ~ppc64 x86"
IUSE="designer"

RDEPEND="
	=kde-frameworks/kconfig-${PVCUT}*:5
	=kde-frameworks/kcoreaddons-${PVCUT}*:5
	=kde-frameworks/kio-${PVCUT}*:5
	=kde-frameworks/kjobwidgets-${PVCUT}*:5
	=kde-frameworks/kparts-${PVCUT}*:5
	=kde-frameworks/kservice-${PVCUT}*:5
	=kde-frameworks/kwallet-${PVCUT}*:5
	>=dev-qt/qtgui-${QTMIN}:5
	>=dev-qt/qtnetwork-${QTMIN}:5
	>=dev-qt/qtwidgets-${QTMIN}:5
	>=dev-qt/qtwebkit-5.212.0_pre20180120:5
	designer? ( =kde-frameworks/kdesignerplugin-${PVCUT}*:5 )
"
DEPEND="${RDEPEND}
	>=dev-qt/qtnetwork-${QTMIN}:5
"

src_configure() {
	local mycmakeargs=(
		-DBUILD_DESIGNERPLUGIN=$(usex designer)
	)
	ecm_src_configure
}
