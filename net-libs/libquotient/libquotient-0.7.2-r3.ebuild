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
KEYWORDS="amd64 arm64 ~ppc64 x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-libs/olm
	dev-libs/openssl:=
	dev-libs/qtkeychain:=[qt5(+)]
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtmultimedia:5
	dev-qt/qtnetwork:5[ssl]
	dev-qt/qtsql:5
"
DEPEND="${RDEPEND}
	test? (
		dev-qt/qtconcurrent:5
		dev-qt/qttest:5
	)
"

PATCHES=(
	# downstream patches
	"${FILESDIR}"/${PN}-0.7.0-no-android.patch
	"${FILESDIR}"/${PN}-0.7.0-no-tests.patch
)

src_configure() {
	local mycmakeargs=(
		-DBUILD_WITH_QT6=OFF
		-DBUILD_TESTING=$(usex test)
		-DQuotient_ENABLE_E2EE=ON
	)
	use test && mycmakeargs+=(
		-DQuotient_INSTALL_TESTS=OFF
	)
	cmake_src_configure
}

src_test() {
	# https://github.com/quotient-im/libQuotient/issues/435
	# testolmaccount requires network connection/server set up
	local myctestargs=(
		-j1
		-E "(testolmaccount)"
	)
	cmake_src_test
}
