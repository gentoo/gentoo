# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

KFMIN=5.82.0
QTMIN=5.15.2
inherit ecm kde.org

DESCRIPTION="Write hybrid ISO files onto a USB disk"
HOMEPAGE="https://community.kde.org/ISOImageWriter"

if [[ ${KDE_BUILD_TYPE} == release ]]; then
	SRC_URI="mirror://kde/unstable/${PN}/${PV}/${P}.tar.xz"
	KEYWORDS="amd64"
fi

LICENSE="GPL-3"
SLOT="5"
IUSE=""

DEPEND="
	app-crypt/gpgme:=[cxx(+),qt5]
	>=dev-qt/qtgui-${QTMIN}:5
	>=dev-qt/qtnetwork-${QTMIN}:5
	>=dev-qt/qtwidgets-${QTMIN}:5
	>=kde-frameworks/karchive-${KFMIN}:5
	>=kde-frameworks/kauth-${KFMIN}:5
	>=kde-frameworks/kcrash-${KFMIN}:5
	>=kde-frameworks/kcoreaddons-${KFMIN}:5
	>=kde-frameworks/ki18n-${KFMIN}:5
	>=kde-frameworks/kiconthemes-${KFMIN}:5
	>=kde-frameworks/solid-${KFMIN}:5
"
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}/${P}-missing-headers.patch" ) # bug 842657
