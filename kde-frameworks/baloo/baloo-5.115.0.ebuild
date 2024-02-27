# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_TEST="forceoptional"
PVCUT=$(ver_cut 1-2)
QTMIN=5.15.9
inherit ecm frameworks.kde.org

DESCRIPTION="Framework for searching and managing metadata"

LICENSE="LGPL-2+"
KEYWORDS="amd64 ~arm ~arm64 ~loong ~ppc64 ~riscv ~x86"
IUSE="kf6compat"

RESTRICT="test" # bug 624250

DEPEND="
	>=dev-db/lmdb-0.9.17
	>=dev-qt/qtdbus-${QTMIN}:5
	>=dev-qt/qtdeclarative-${QTMIN}:5
	>=dev-qt/qtgui-${QTMIN}:5
	>=dev-qt/qtwidgets-${QTMIN}:5
	=kde-frameworks/kconfig-${PVCUT}*:5
	=kde-frameworks/kcoreaddons-${PVCUT}*:5
	=kde-frameworks/kcrash-${PVCUT}*:5
	=kde-frameworks/kdbusaddons-${PVCUT}*:5
	=kde-frameworks/kfilemetadata-${PVCUT}*:5
	=kde-frameworks/ki18n-${PVCUT}*:5
	=kde-frameworks/kidletime-${PVCUT}*:5
	=kde-frameworks/kio-${PVCUT}*:5
	=kde-frameworks/solid-${PVCUT}*:5
"
RDEPEND="${DEPEND}
	kf6compat? ( kde-frameworks/baloo:6 )
"

src_configure() {
	local mycmakeargs=(
		-DBUILD_INDEXER_SERVICE=$(usex !kf6compat)
	)

	ecm_src_configure
}
