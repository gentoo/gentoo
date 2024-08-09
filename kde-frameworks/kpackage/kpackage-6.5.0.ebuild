# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PVCUT=$(ver_cut 1-2)
QTMIN=6.6.2
inherit ecm frameworks.kde.org

DESCRIPTION="Framework to install and load packages of non binary content"

LICENSE="LGPL-2+"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~riscv ~x86"
IUSE="man"

DEPEND="
	>=dev-qt/qtbase-${QTMIN}:6[dbus]
	=kde-frameworks/karchive-${PVCUT}*:6
	=kde-frameworks/kcoreaddons-${PVCUT}*:6
	=kde-frameworks/ki18n-${PVCUT}*:6
"
RDEPEND="${DEPEND}"
BDEPEND="man? ( >=kde-frameworks/kdoctools-${PVCUT}:6 )"

CMAKE_SKIP_TESTS=(
	# bug 650214
	plasma-plasmoidpackagetest
	# requires network access
	testpackage-appstream
)

src_configure() {
	local mycmakeargs=(
		$(cmake_use_find_package man KF6DocTools)
	)

	ecm_src_configure
}
