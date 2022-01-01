# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

BOGUS=1
KFMIN=5.71.0
PVCUT=$(ver_cut 1-3)
QTMIN=5.14.2
inherit ecm kde.org

DESCRIPTION="KDE Plasma control module for Plymouth"
HOMEPAGE="https://invent.kde.org/plasma/plymouth-kcm"

LICENSE="GPL-2+"
SLOT="5"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~x86"
IUSE=""

DEPEND="
	>=dev-qt/qtdeclarative-${QTMIN}:5
	>=dev-qt/qtgui-${QTMIN}:5
	>=dev-qt/qtquickcontrols-${QTMIN}:5
	>=dev-qt/qtwidgets-${QTMIN}:5
	>=kde-frameworks/karchive-${KFMIN}:5
	>=kde-frameworks/kauth-${KFMIN}:5
	>=kde-frameworks/kconfig-${KFMIN}:5
	>=kde-frameworks/kcoreaddons-${KFMIN}:5
	>=kde-frameworks/kdeclarative-${KFMIN}:5
	>=kde-frameworks/ki18n-${KFMIN}:5
	>=kde-frameworks/kio-${KFMIN}:5
	>=kde-frameworks/knewstuff-${KFMIN}:5
	>=kde-frameworks/kwidgetsaddons-${KFMIN}:5
	sys-boot/plymouth
"
RDEPEND="${DEPEND}
	>=kde-plasma/kde-cli-tools-${PVCUT}:5
"

DOCS=( CONTRIBUTORS )
