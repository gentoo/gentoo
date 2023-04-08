# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

QTMIN=5.15.5
VIRTUALDBUS_TEST="true"
inherit ecm frameworks.kde.org

DESCRIPTION="Framework for registering services and applications per freedesktop standards"

LICENSE="LGPL-2+"
KEYWORDS="~amd64 ~arm ~arm64 ~loong ~ppc64 ~riscv ~x86"
IUSE="X"

DEPEND="
	>=dev-qt/qtdbus-${QTMIN}:5
	X? ( >=dev-qt/qtx11extras-${QTMIN}:5 )
"
RDEPEND="${DEPEND}"
BDEPEND=">=dev-qt/linguist-tools-${QTMIN}:5"

src_configure() {
	local mycmakeargs=(
		$(cmake_use_find_package X Qt5X11Extras)
	)

	ecm_src_configure
}
