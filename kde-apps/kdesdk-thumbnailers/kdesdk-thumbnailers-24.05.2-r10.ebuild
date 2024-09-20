# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

KFMIN=6.3.0
QTMIN=6.6.2
inherit ecm gear.kde.org

DESCRIPTION="Thumbnail generator for PO files"

LICENSE="GPL-2" # TODO: CHECK
SLOT="6"
KEYWORDS="amd64 arm64 ~riscv ~x86"
IUSE=""

DEPEND="
	>=dev-qt/qtbase-${QTMIN}:6[gui,widgets]
	>=kde-frameworks/kconfig-${KFMIN}:6
	>=kde-frameworks/ki18n-${KFMIN}:6
	>=kde-frameworks/kio-${KFMIN}:6
	>=kde-frameworks/kwidgetsaddons-${KFMIN}:6
	sys-devel/gettext
"
RDEPEND="${DEPEND}
	>=kde-apps/${PN}-common-${PV}
"

ECM_REMOVE_FROM_INSTALL=(
	/usr/share/config.kcfg/pocreatorsettings.kcfg
)

src_prepare() {
	ecm_src_prepare
	ecm_punt_po_install
}
