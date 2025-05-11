# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

QTMIN=6.7.2
inherit ecm frameworks.kde.org

DESCRIPTION="Framework to install and load packages of non binary content"

LICENSE="LGPL-2+"
KEYWORDS="~amd64 ~arm64 ~loong ~ppc64 ~riscv ~x86"
IUSE="man"

DEPEND="
	>=dev-qt/qtbase-${QTMIN}:6[dbus]
	=kde-frameworks/karchive-${KDE_CATV}*:6
	=kde-frameworks/kcoreaddons-${KDE_CATV}*:6
	=kde-frameworks/ki18n-${KDE_CATV}*:6
"
RDEPEND="${DEPEND}"
BDEPEND="man? ( >=kde-frameworks/kdoctools-${KDE_CATV}:6 )"

CMAKE_SKIP_TESTS=(
	# bugs 650214, 939041
	plasmoidpackagetest
	# requires network access
	testpackage-appstream
)

src_configure() {
	local mycmakeargs=(
		$(cmake_use_find_package man KF6DocTools)
	)

	ecm_src_configure
}
