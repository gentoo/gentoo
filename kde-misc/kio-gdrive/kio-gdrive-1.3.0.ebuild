# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

ECM_HANDBOOK="forceoptional"
ECM_TEST="optional"
KFMIN=5.60.0
QTMIN=5.12.3
inherit ecm kde.org

DESCRIPTION="KIO Slave for Google Drive service"
HOMEPAGE="https://phabricator.kde.org/project/profile/72/"

if [[ ${KDE_BUILD_TYPE} != live ]] ; then
	SRC_URI="mirror://kde/stable/${PN}/${PV}/src/${P}.tar.xz"
	KEYWORDS="~amd64 ~arm64 ~x86"
fi

LICENSE="GPL-2+"
SLOT="5"
IUSE="+kaccounts"

BDEPEND="dev-util/intltool"
RDEPEND="
	>=dev-qt/qtwidgets-${QTMIN}:5
	>=kde-apps/libkgapi-19.08.0:5
	>=kde-frameworks/kcoreaddons-${KFMIN}:5
	>=kde-frameworks/ki18n-${KFMIN}:5
	>=kde-frameworks/kio-${KFMIN}:5
	>=kde-frameworks/knotifications-${KFMIN}:5
	kaccounts? ( >=kde-apps/kaccounts-integration-20.03.90:5 )
	!kaccounts? ( dev-libs/qtkeychain:=[qt5(+)] )
"
DEPEND="${RDEPEND}
	>=dev-qt/qtgui-${QTMIN}:5
	>=dev-qt/qtnetwork-${QTMIN}:5
"

DOCS=( README.md )

src_configure() {
	local mycmakeargs=(
		$(cmake_use_find_package kaccounts KAccounts)
	)
	ecm_src_configure
}
