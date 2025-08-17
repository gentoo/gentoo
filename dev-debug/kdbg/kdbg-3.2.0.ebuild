# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_HANDBOOK="true"
KFMIN=6.9.0
QTMIN=6.8.1
inherit ecm xdg

DESCRIPTION="Graphical debugger interface"
HOMEPAGE="https://www.kdbg.org/"
SRC_URI="https://github.com/j6t/${PN}/archive/refs/tags/${P}.tar.gz -> ${P}.gh.tar.gz"
S="${WORKDIR}/${PN}-${P}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~riscv ~x86"

DEPEND="
	>=dev-qt/qt5compat-${QTMIN}:6
	>=dev-qt/qtbase-${QTMIN}:6[gui,widgets]
	>=kde-frameworks/kconfig-${KFMIN}:6
	>=kde-frameworks/kconfigwidgets-${KFMIN}:6
	>=kde-frameworks/kcoreaddons-${KFMIN}:6
	>=kde-frameworks/ki18n-${KFMIN}:6
	>=kde-frameworks/kiconthemes-${KFMIN}:6
	>=kde-frameworks/kwidgetsaddons-${KFMIN}:6
	>=kde-frameworks/kwindowsystem-${KFMIN}:6[X]
	>=kde-frameworks/kxmlgui-${KFMIN}:6
"
RDEPEND="${DEPEND}
	!${CATEGORY}/${PN}:5
	dev-debug/gdb
"

src_prepare() {
	ecm_src_prepare
	if ! use handbook; then
		cmake_run_in kdbg cmake_comment_add_subdirectory doc
	fi
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_FOR_KDE_VERSION=6
	)
	ecm_src_configure
}
