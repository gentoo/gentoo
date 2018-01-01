# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

KDE_EXAMPLES="true"
inherit kde5

DESCRIPTION="Library for writing accessibility clients such as screen readers"
HOMEPAGE="https://accessibility.kde.org/ https://cgit.kde.org/libqaccessibilityclient.git"
SRC_URI="mirror://kde/unstable/${PN}/${P}.tar.xz"

LICENSE="LGPL-2.1"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="
	$(add_qt_dep qtdbus)
	$(add_qt_dep qtgui)
	$(add_qt_dep qtwidgets)
"
RDEPEND="${DEPEND}"

src_prepare() {
	kde5_src_prepare
	cmake_comment_add_subdirectory tests
}

src_configure() {
	local mycmakeargs=(
		-DQT5_BUILD=ON
	)
	kde5_src_configure
}
