# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_PYTHON_BINDINGS="off"
QTMIN=6.7.2
inherit ecm frameworks.kde.org

DESCRIPTION="Implementation of Status Notifier Items"

LICENSE="LGPL-2+"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~riscv ~x86"
IUSE="X"

# slot op: Qt6::WidgetsPrivate use
RDEPEND="
	>=dev-qt/qtbase-${QTMIN}:6=[dbus,gui,widgets]
	=kde-frameworks/kwindowsystem-${KDE_CATV}*:6[X?]
"
DEPEND="${RDEPEND}"
BDEPEND=">=dev-qt/qttools-${QTMIN}:6[linguist]"

src_configure() {
	local mycmakeargs=(
		-DWITHOUT_X11=$(usex !X)
	)

	ecm_src_configure
}
