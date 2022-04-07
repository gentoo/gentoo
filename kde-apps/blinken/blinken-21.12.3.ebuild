# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_HANDBOOK="forceoptional"
KFMIN=5.88.0
QTMIN=5.15.2
inherit ecm kde.org

DESCRIPTION="Memory enhancement game based on KDE Frameworks"
HOMEPAGE="https://apps.kde.org/blinken/ https://edu.kde.org/blinken/"

LICENSE="GPL-2" # TODO: CHECK
SLOT="5"
KEYWORDS="amd64 ~arm64 ~riscv ~x86"
IUSE=""

DEPEND="
	>=dev-qt/qtgui-${QTMIN}:5
	>=dev-qt/qtsvg-${QTMIN}:5
	>=dev-qt/qtwidgets-${QTMIN}:5
	>=kde-frameworks/kconfig-${KFMIN}:5
	>=kde-frameworks/kcoreaddons-${KFMIN}:5
	>=kde-frameworks/kcrash-${KFMIN}:5
	>=kde-frameworks/kdbusaddons-${KFMIN}:5
	>=kde-frameworks/kguiaddons-${KFMIN}:5
	>=kde-frameworks/ki18n-${KFMIN}:5
	>=kde-frameworks/kxmlgui-${KFMIN}:5
	>=media-libs/phonon-4.11.0
"
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}/${P}-missing-link.patch" )

src_install() {
	ecm_src_install
	rm "${ED}"/usr/share/${PN}/README.packagers || die
}
