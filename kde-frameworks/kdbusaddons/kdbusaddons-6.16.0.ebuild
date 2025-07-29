# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

QTMIN=6.7.2
VIRTUALDBUS_TEST="true"
inherit ecm frameworks.kde.org

DESCRIPTION="Framework for registering services and applications per freedesktop standards"

LICENSE="LGPL-2+"
KEYWORDS="~amd64 arm64 ~loong ~ppc64 ~riscv ~x86"
IUSE="X"

# slot op: Uses Qt6::GuiPrivate for qtx11extras_p.h
DEPEND="
	>=dev-qt/qtbase-${QTMIN}:6[dbus]
	X? ( >=dev-qt/qtbase-${QTMIN}:6=[gui,X] )
"
RDEPEND="${DEPEND}"
BDEPEND=">=dev-qt/qttools-${QTMIN}:6[linguist]"

src_configure() {
	local mycmakeargs=(
		-DWITH_X11=$(usex X)
	)

	ecm_src_configure
}
