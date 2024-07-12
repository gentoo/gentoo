# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_DESIGNERPLUGIN="true"
ECM_TEST="false"
PVCUT=$(ver_cut 1-2)
QTMIN=6.6.2
inherit ecm frameworks.kde.org

DESCRIPTION="Framework for downloading and sharing additional application data"

LICENSE="LGPL-2+"
KEYWORDS="~amd64 ~arm64 ~riscv ~x86"
IUSE="opds"

DEPEND="
	>=dev-qt/qtbase-${QTMIN}:6[gui,network,widgets,xml]
	>=dev-qt/qtdeclarative-${QTMIN}:6[widgets]
	=kde-frameworks/attica-${PVCUT}*:6
	=kde-frameworks/karchive-${PVCUT}*:6
	=kde-frameworks/kconfig-${PVCUT}*:6
	=kde-frameworks/kcoreaddons-${PVCUT}*:6
	=kde-frameworks/ki18n-${PVCUT}*:6
	=kde-frameworks/kpackage-${PVCUT}*:6
	=kde-frameworks/kwidgetsaddons-${PVCUT}*:6
	opds? ( =kde-frameworks/syndication-${PVCUT}*:6 )
"
RDEPEND="${DEPEND}
	>=kde-frameworks/kirigami-${PVCUT}:6
"

src_configure() {
	local mycmakeargs=(
		$(cmake_use_find_package opds KF6Syndication)
	)

	ecm_src_configure
}
