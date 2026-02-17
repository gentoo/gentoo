# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Qt (C++) widgets to manage color inputs"
HOMEPAGE="https://gitlab.com/mattbas/Qt-Color-Widgets/"
SRC_URI="
	https://gitlab.com/mattbas/Qt-Color-Widgets/-/archive/${PV}/Qt-Color-Widgets-${PV}.tar.bz2
"
S="${WORKDIR}/Qt-Color-Widgets-${PV}"

LICENSE="LGPL-3+"
SLOT="0/2" # ${COLORWIDGET_PROJECT_NAME}_VERSION_MAJOR in CMakeLists.txt
KEYWORDS="~amd64 ~arm64 ~x86"

IUSE="designer"

DEPEND="
	dev-qt/qtbase:6[widgets]
	designer? ( dev-qt/qttools:6[designer] )
"
RDEPEND="${DEPEND}"

src_configure() {
	local mycmakeargs=(
		-DQT_VERSION_MAJOR=6
		-DBUILD_SHARED_LIBS=ON
		-DQTCOLORWIDGETS_DESIGNER_PLUGIN=$(usex designer)
	)
	cmake_src_configure
}
