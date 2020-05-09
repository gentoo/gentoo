# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

QTMIN=5.12.3
VIRTUALDBUS_TEST="true"
inherit ecm kde.org

DESCRIPTION="Framework for registering services and applications per freedesktop standards"
LICENSE="LGPL-2+"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~x86"
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
		$(cmake_use_find_package X Qt5X11Extras)
	)

	ecm_src_configure
}
