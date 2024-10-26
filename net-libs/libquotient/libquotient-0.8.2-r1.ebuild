# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Qt-based SDK to develop applications for Matrix"
HOMEPAGE="https://github.com/quotient-im/libQuotient"
SRC_URI="https://github.com/quotient-im/libQuotient/archive/${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/libQuotient-${PV}"

LICENSE="LGPL-2+"
SLOT="0/${PV}" # FIXME: check soname on next version bump
KEYWORDS="amd64 arm64 ~ppc64 x86"
IUSE="test"

RESTRICT="!test? ( test )"

RDEPEND="
	dev-libs/olm
	dev-libs/openssl:=
	>=dev-libs/qtkeychain-0.14.1-r1:=[qt6]
	dev-qt/qtbase:6[gui,network,sql,ssl]
	dev-qt/qtmultimedia:6
"
DEPEND="${RDEPEND}
	test? ( dev-qt/qtbase:6[concurrent] )
"

PATCHES=(
	# downstream patches
	"${FILESDIR}"/${PN}-0.8.0-no-android.patch
	"${FILESDIR}"/${PN}-0.8.0-no-tests.patch
)

src_configure() {
	local mycmakeargs=(
		-DBUILD_TESTING=$(usex test)
		-DQuotient_ENABLE_E2EE=ON
		-DBUILD_WITH_QT6=ON
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
