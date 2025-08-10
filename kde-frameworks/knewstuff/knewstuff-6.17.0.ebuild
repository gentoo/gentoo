# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_DESIGNERPLUGIN="true"
ECM_TEST="false"
QTMIN=6.7.2
inherit ecm frameworks.kde.org

DESCRIPTION="Framework for downloading and sharing additional application data"

LICENSE="LGPL-2+"
KEYWORDS="~amd64 ~arm64 ~loong ~ppc64 ~riscv ~x86"
IUSE="opds"

DEPEND="
	>=dev-qt/qtbase-${QTMIN}:6[gui,network,widgets,xml]
	>=dev-qt/qtdeclarative-${QTMIN}:6[widgets]
	=kde-frameworks/attica-${KDE_CATV}*:6
	=kde-frameworks/karchive-${KDE_CATV}*:6
	=kde-frameworks/kconfig-${KDE_CATV}*:6
	=kde-frameworks/kcoreaddons-${KDE_CATV}*:6
	=kde-frameworks/ki18n-${KDE_CATV}*:6
	=kde-frameworks/kpackage-${KDE_CATV}*:6
	=kde-frameworks/kwidgetsaddons-${KDE_CATV}*:6
	opds? ( =kde-frameworks/syndication-${KDE_CATV}*:6 )
"
RDEPEND="${DEPEND}
	>=kde-frameworks/kcmutils-${KDE_CATV}:6
	>=kde-frameworks/kirigami-${KDE_CATV}:6
"

src_configure() {
	local mycmakeargs=(
		$(cmake_use_find_package opds KF6Syndication)
	)

	ecm_src_configure
}
