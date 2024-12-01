# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

QTMIN=6.6.2
inherit ecm frameworks.kde.org

DESCRIPTION="Framework to handle global shortcuts"

LICENSE="LGPL-2+"
KEYWORDS="amd64 arm64 ppc64 ~riscv ~x86"
IUSE="X"

# slot op: WITH_X11 uses Qt6::GuiPrivate for qtx11extras_p.h
RDEPEND="
	>=dev-qt/qtbase-${QTMIN}:6[dbus,gui,widgets]
	X? ( >=dev-qt/qtbase-${QTMIN}:6=[X] )
"
DEPEND="${RDEPEND}"
BDEPEND=">=dev-qt/qttools-${QTMIN}:6[linguist]"

PATCHES=( "${FILESDIR}/${P}-with_x11.patch" )

src_configure() {
	local mycmakeargs=(
		-DWITH_X11=$(usex X)
	)
	ecm_src_configure
}
