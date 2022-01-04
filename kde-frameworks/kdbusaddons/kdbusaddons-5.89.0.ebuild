# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

QTMIN=5.15.2
VIRTUALDBUS_TEST="true"
inherit ecm kde.org

DESCRIPTION="Framework for registering services and applications per freedesktop standards"
LICENSE="LGPL-2+"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~riscv ~x86"
IUSE="nls X"

BDEPEND="
	nls? ( >=dev-qt/linguist-tools-${QTMIN}:5 )
"
DEPEND="
	>=dev-qt/qtdbus-${QTMIN}:5
	X? ( >=dev-qt/qtx11extras-${QTMIN}:5 )
"
RDEPEND="${DEPEND}"

src_configure() {
	local mycmakeargs=(
		-DCMAKE_DISABLE_FIND_PACKAGE_PythonModuleGeneration=ON # bug 746866
		$(cmake_use_find_package X Qt5X11Extras)
	)

	ecm_src_configure
}
