# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake multibuild

DESCRIPTION="Qt-based SDK to develop applications for Matrix"
HOMEPAGE="https://github.com/quotient-im/libQuotient"
SRC_URI="https://github.com/quotient-im/libQuotient/archive/${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/libQuotient-${PV}"

LICENSE="LGPL-2+"
SLOT="0/${PV}" # FIXME: check soname on next version bump
KEYWORDS="~amd64 ~arm64 ~ppc64 ~x86"
IUSE="+qt5 qt6 test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-libs/olm
	dev-libs/openssl:=
	qt5? (
		dev-libs/qtkeychain:=[qt5(+)]
		dev-qt/qtcore:5
		dev-qt/qtgui:5
		dev-qt/qtmultimedia:5
		dev-qt/qtnetwork:5[ssl]
		dev-qt/qtsql:5
	)
	qt6? (
		>=dev-libs/qtkeychain-0.14.1-r1:=[qt6]
		dev-qt/qtbase:6[gui,network,sql,ssl]
		dev-qt/qtmultimedia:6
	)
"
DEPEND="${RDEPEND}
	test? (
		qt5? (
			dev-qt/qtconcurrent:5
			dev-qt/qttest:5
		)
		qt6? ( dev-qt/qtbase:6[concurrent] )
	)
"

PATCHES=(
	# downstream patches
	"${FILESDIR}"/${PN}-0.8.0-no-android.patch
	"${FILESDIR}"/${PN}-0.8.0-no-tests.patch
)

pkg_setup() {
	MULTIBUILD_VARIANTS=( $(usev qt5) $(usev qt6) )
}

src_configure() {
	my_src_configure() {
		local mycmakeargs=(
			-DBUILD_TESTING=$(usex test)
			-DQuotient_ENABLE_E2EE=ON
		)

		if [[ ${MULTIBUILD_VARIANT} == qt6 ]]; then
			mycmakeargs+=( -DBUILD_WITH_QT6=ON )
		else
			mycmakeargs+=( -DBUILD_WITH_QT6=OFF )
		fi

		use test && mycmakeargs+=(
			-DQuotient_INSTALL_TESTS=OFF
		)
		cmake_src_configure
	}

	multibuild_foreach_variant my_src_configure
}

src_compile() {
	multibuild_foreach_variant cmake_src_compile
}

src_install() {
	multibuild_foreach_variant cmake_src_install
}

src_test() {
	# https://github.com/quotient-im/libQuotient/issues/435
	# testolmaccount requires network connection/server set up
	local myctestargs=(
		-j1
		-E "(testolmaccount)"
	)
	multibuild_foreach_variant cmake_src_test
}
