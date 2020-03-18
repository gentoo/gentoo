# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PVCUT=$(ver_cut 1-3)
KFMIN=5.60.0
QTMIN=5.12.3
inherit ecm kde.org

DESCRIPTION="KDE Telepathy file manager plugin to send files to contacts"
HOMEPAGE="https://community.kde.org/Real-Time_Communication_and_Collaboration"

LICENSE="LGPL-2.1+"
SLOT="5"
KEYWORDS="amd64 arm64 x86"
IUSE=""

COMMON_DEPEND="
	>=kde-frameworks/kcoreaddons-${KFMIN}:5
	>=kde-frameworks/ki18n-${KFMIN}:5
	>=kde-frameworks/kiconthemes-${KFMIN}:5
	>=kde-frameworks/kio-${KFMIN}:5
	>=kde-frameworks/kwidgetsaddons-${KFMIN}:5
	>=kde-apps/ktp-common-internals-${PVCUT}:5
	>=dev-qt/qtdbus-${QTMIN}:5
	>=dev-qt/qtgui-${QTMIN}:5
	>=dev-qt/qtwidgets-${QTMIN}:5
	net-libs/telepathy-qt[qt5(+)]
"
DEPEND="${COMMON_DEPEND}
	>=kde-frameworks/kcmutils-${KFMIN}:5
"
RDEPEND="${COMMON_DEPEND}
	>=kde-apps/ktp-contact-list-${PVCUT}:5
	>=kde-apps/ktp-filetransfer-handler-${PVCUT}:5
"
