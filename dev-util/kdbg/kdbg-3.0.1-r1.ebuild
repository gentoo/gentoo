# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_HANDBOOK="true"
KFMIN=5.85.0
QTMIN=5.15.2
inherit ecm

DESCRIPTION="Graphical debugger interface"
HOMEPAGE="https://www.kdbg.org/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="5"
KEYWORDS="~amd64 ~riscv ~x86"
IUSE=""

DEPEND="
	>=dev-qt/qtgui-${QTMIN}:5
	>=dev-qt/qtwidgets-${QTMIN}:5
	>=kde-frameworks/kconfig-${KFMIN}:5
	>=kde-frameworks/kconfigwidgets-${KFMIN}:5
	>=kde-frameworks/kcoreaddons-${KFMIN}:5
	>=kde-frameworks/ki18n-${KFMIN}:5
	>=kde-frameworks/kiconthemes-${KFMIN}:5
	>=kde-frameworks/kwidgetsaddons-${KFMIN}:5
	>=kde-frameworks/kwindowsystem-${KFMIN}:5
	>=kde-frameworks/kxmlgui-${KFMIN}:5
"
RDEPEND="${DEPEND}
	sys-devel/gdb
"

PATCHES=(
	"${FILESDIR}"/${P}-fix-rare-memleak.patch
	"${FILESDIR}"/${P}-usable-trace.patch
)

src_prepare() {
	# allow documentation to be handled by eclass
	mv kdbg/doc . || die
	sed -i -e '/add_subdirectory(doc)/d' kdbg/CMakeLists.txt || die
	echo "add_subdirectory ( doc ) " >> CMakeLists.txt || die

	ecm_src_prepare
}
