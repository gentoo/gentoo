# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_HANDBOOK="forceoptional"
KFMIN=5.82.0
QTMIN=5.15.5
inherit ecm kde.org

DESCRIPTION="Photo geotagging program"
HOMEPAGE="https://kgeotag.kde.org/ https://apps.kde.org/kgeotag/"

if [[ ${KDE_BUILD_TYPE} != live ]]; then
	SRC_URI="mirror://kde/stable/${PN}/${PV}/${P}.tar.xz"
	KEYWORDS="~amd64"
fi

LICENSE="GPL-3+"
SLOT="5"

DEPEND="
	>=dev-qt/qtgui-${QTMIN}:5
	>=dev-qt/qtnetwork-${QTMIN}:5
	>=dev-qt/qtwidgets-${QTMIN}:5
	>=kde-apps/libkexiv2-21.12.0:5
	>=kde-apps/marble-21.12.0:5
	>=kde-frameworks/kconfig-${KFMIN}:5
	>=kde-frameworks/kconfigwidgets-${KFMIN}:5
	>=kde-frameworks/kcoreaddons-${KFMIN}:5
	>=kde-frameworks/kcrash-${KFMIN}:5
	>=kde-frameworks/ki18n-${KFMIN}:5
	>=kde-frameworks/kxmlgui-${KFMIN}:5
"
RDEPEND="${DEPEND}"

DOCS=( CHANGELOG.rst README.md )

PATCHES=( "${FILESDIR}/${PN}-1.3.1-cmake.patch" )
