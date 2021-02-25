# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="Qt5-based SDK to develop applications for Matrix"
HOMEPAGE="https://github.com/quotient-im/libQuotient"
SRC_URI="https://github.com/quotient-im/libQuotient/archive/${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/libQuotient-${PV}"

LICENSE="LGPL-2+"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtmultimedia:5
	dev-qt/qtnetwork:5
"
RDEPEND="${DEPEND}"

PATCHES=(
	# downstream patches
	"${FILESDIR}"/${PN}-0.6.3-no-android.patch
	"${FILESDIR}"/${PN}-0.6.3-no-tests.patch
)

src_configure() {
	local mycmakeargs=(
		-DQuotient_INSTALL_TESTS=OFF
		-DQuotient_ENABLE_E2EE=OFF # TODO: libolm, libqtolm not packaged
		-DCMAKE_DISABLE_FIND_PACKAGE_Git=ON # no thanks.
	)
	cmake_src_configure
}
