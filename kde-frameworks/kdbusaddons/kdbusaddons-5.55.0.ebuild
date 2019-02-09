# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

VIRTUALDBUS_TEST="true"
inherit kde5

DESCRIPTION="Framework for registering services and applications per freedesktop standards"
LICENSE="LGPL-2+"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"
IUSE="nls X"

BDEPEND="
	nls? ( $(add_qt_dep linguist-tools) )
"
DEPEND="
	$(add_qt_dep qtdbus)
	X? ( $(add_qt_dep qtx11extras) )
"
RDEPEND="${DEPEND}"

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_find_package X Qt5X11Extras)
	)

	kde5_src_configure
}
