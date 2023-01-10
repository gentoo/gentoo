# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Qt-based SDK to develop applications for Matrix"
HOMEPAGE="https://github.com/quotient-im/libQuotient"
SRC_URI="https://github.com/quotient-im/libQuotient/archive/${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/libQuotient-${PV}"

LICENSE="LGPL-2+"
SLOT="0/$(ver_cut 1-2)"
KEYWORDS="~amd64 ~arm64 ~ppc64"
IUSE=""

DEPEND="
	dev-libs/qtkeychain:=[qt5(+)]
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtmultimedia:5
	dev-qt/qtnetwork:5[ssl]
"
RDEPEND="${DEPEND}"

PATCHES=(
	# downstream patches
	"${FILESDIR}"/${PN}-0.7.0-no-android.patch
	"${FILESDIR}"/${PN}-0.7.0-no-tests.patch
)

src_configure() {
	local mycmakeargs=(
		-DBUILD_WITH_QT6=OFF
		-DBUILD_TESTING=OFF
		-DQuotient_ENABLE_E2EE=OFF # TODO: libolm, libqtolm not packaged
	)
	cmake_src_configure
}
