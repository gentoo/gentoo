# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_HANDBOOK="forceoff"
ECM_TEST="true"
KDE_ORG_NAME="kde-cli-tools"
KFMIN=6.14.0
QTMIN=6.8.1
inherit ecm plasma.kde.org xdg

DESCRIPTION="File Type Editor"
HOMEPAGE="https://invent.kde.org/plasma/kde-cli-tools"

LICENSE="GPL-2" # TODO: CHECK
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~loong ~ppc64 ~riscv ~x86"
IUSE=""

# requires running Plasma environment
RESTRICT="test"

DEPEND="
	>=dev-qt/qtbase-${QTMIN}:6[dbus,gui,widgets]
	>=kde-frameworks/kcmutils-${KFMIN}:6
	>=kde-frameworks/kcompletion-${KFMIN}:6
	>=kde-frameworks/kconfig-${KFMIN}:6
	>=kde-frameworks/kcoreaddons-${KFMIN}:6
	>=kde-frameworks/ki18n-${KFMIN}:6
	>=kde-frameworks/kiconthemes-${KFMIN}:6
	>=kde-frameworks/kio-${KFMIN}:6
	>=kde-frameworks/kparts-${KFMIN}:6
	>=kde-frameworks/kservice-${KFMIN}:6
	>=kde-frameworks/kwindowsystem-${KFMIN}:6
"
RDEPEND="${DEPEND}
	!<${CATEGORY}/${KDE_ORG_NAME}-6.2.4:*
	>=${CATEGORY}/${KDE_ORG_NAME}-common-${PV}
"
BDEPEND=">=kde-frameworks/kcmutils-${KFMIN}:6"

# downstream split
PATCHES=( "${FILESDIR}/${PN}-6.2.4-build-restrict.patch" )

src_prepare() {
	ecm_src_prepare
	ecm_punt_po_install
}
