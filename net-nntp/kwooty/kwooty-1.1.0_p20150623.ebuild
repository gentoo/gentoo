# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

KFMIN=5.60.0
QTMIN=5.12.3
inherit ecm kde.org

DESCRIPTION="Friendly nzb linux usenet binary client"
HOMEPAGE="https://www.linux-apps.com/content/show.php/Kwooty?content=114385"
SRC_URI="https://dev.gentoo.org/~kensington/distfiles/${P}.tar.xz"

LICENSE="GPL-2+"
SLOT="5"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="
	>=dev-qt/qtdbus-${QTMIN}:5
	>=dev-qt/qtgui-${QTMIN}:5
	>=dev-qt/qtnetwork-${QTMIN}:5
	>=dev-qt/qtwidgets-${QTMIN}:5
	>=kde-frameworks/kcmutils-${KFMIN}:5
	>=kde-frameworks/kconfig-${KFMIN}:5
	>=kde-frameworks/kconfigwidgets-${KFMIN}:5
	>=kde-frameworks/kcoreaddons-${KFMIN}:5
	>=kde-frameworks/kdelibs4support-${KFMIN}:5
	>=kde-frameworks/kguiaddons-${KFMIN}:5
	>=kde-frameworks/ki18n-${KFMIN}:5
	>=kde-frameworks/kiconthemes-${KFMIN}:5
	>=kde-frameworks/kio-${KFMIN}:5
	>=kde-frameworks/knotifications-${KFMIN}:5
	>=kde-frameworks/kservice-${KFMIN}:5
	>=kde-frameworks/kwallet-${KFMIN}:5
	>=kde-frameworks/kwidgetsaddons-${KFMIN}:5
	>=kde-frameworks/kwindowsystem-${KFMIN}:5
	>=kde-frameworks/kxmlgui-${KFMIN}:5
"
RDEPEND="${DEPEND}
	!net-nntp/kwooty:4
"

PATCHES=( "${FILESDIR}/${P}-dep.patch" )

src_prepare() {
	ecm_src_prepare
	ecm_punt_bogus_dep KF5 DocTools
}

pkg_postinst() {
	ecm_pkg_postinst

	if ! has_version "app-arch/par2cmdline" ; then
		elog "For automatic file repairing please install app-arch/par2cmdline."
	fi

	if ! has_version "app-arch/unrar" ; then
		elog "For automatic RAR archive extraction please install app-arch/unrar."
	fi

	if ! has_version "app-arch/p7zip" ; then
		elog "For automatic (7)zip archive extraction please install app-arch/p7zip."
	fi
}
