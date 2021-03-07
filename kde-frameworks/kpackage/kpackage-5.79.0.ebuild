# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PVCUT=$(ver_cut 1-2)
QTMIN=5.15.2
inherit ecm kde.org

DESCRIPTION="Framework to install and load packages of non binary content"

LICENSE="LGPL-2+"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~x86"
IUSE="man"

BDEPEND="
	man? ( >=kde-frameworks/kdoctools-${PVCUT}:5 )
"
DEPEND="
	>=dev-qt/qtdbus-${QTMIN}:5
	=kde-frameworks/karchive-${PVCUT}*:5
	=kde-frameworks/kcoreaddons-${PVCUT}*:5
	=kde-frameworks/ki18n-${PVCUT}*:5
"
RDEPEND="${DEPEND}"

src_configure() {
	local mycmakeargs=(
		$(cmake_use_find_package man KF5DocTools)
	)

	ecm_src_configure
}

src_test() {
	#bug 650214
	local myctestargs=( -E "(plasma-plasmoidpackagetest)" )
	ecm_src_test
}
