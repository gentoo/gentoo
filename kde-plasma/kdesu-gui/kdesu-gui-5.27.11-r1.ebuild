# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_HANDBOOK="forceoff"
ECM_TEST="false"
KDE_ORG_NAME="kde-cli-tools"
KFMIN=5.106.0
QTMIN=5.15.9
inherit ecm plasma.kde.org

DESCRIPTION="Graphical frontend for KDE Frameworks' kdesu"
HOMEPAGE="https://invent.kde.org/plasma/kde-cli-tools"

LICENSE="GPL-2" # TODO: CHECK
SLOT="0"
KEYWORDS="~arm ~loong x86"

DEPEND="
	>=dev-qt/qtgui-${QTMIN}:5
	>=dev-qt/qtwidgets-${QTMIN}:5
	>=kde-frameworks/kconfig-${KFMIN}:5
	>=kde-frameworks/kcoreaddons-${KFMIN}:5
	>=kde-frameworks/kdesu-${KFMIN}:5
	>=kde-frameworks/ki18n-${KFMIN}:5
	>=kde-frameworks/kwidgetsaddons-${KFMIN}:5
	>=kde-frameworks/kwindowsystem-${KFMIN}:5[X]
"
RDEPEND="${DEPEND}
	!<${CATEGORY}/${KDE_ORG_NAME}-6.1.4-r2:*[kdesu(+)]
	>=${CATEGORY}/${KDE_ORG_NAME}-common-${PV}
	sys-apps/dbus[X]
"

PATCHES=(
	"${FILESDIR}/${P}-build-only-kdesu.patch" # downstream split
	"${FILESDIR}/${P}-cmake.patch" # bug 939081, pending upstream MR
)

src_prepare() {
	ecm_src_prepare
	ecm_punt_po_install
}

src_install() {
	ecm_src_install
	dosym ../$(get_libdir)/libexec/kf5/kdesu /usr/bin/kdesu
}
