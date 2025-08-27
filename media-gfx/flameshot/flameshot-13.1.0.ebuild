# Copyright 2021-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

QTCW_COMMIT=8491078434b24cba295b5e41cc0d2a94c7049a5b # why ...
inherit cmake flag-o-matic xdg

DESCRIPTION="Powerful yet simple to use screenshot software"
HOMEPAGE="https://flameshot.org https://github.com/flameshot-org/flameshot"
SRC_URI="https://github.com/flameshot-org/flameshot/archive/v${PV}.tar.gz -> ${P}.tar.gz
https://gitlab.com/mattbas/Qt-Color-Widgets/-/archive/${QTCW_COMMIT}/${PN}-qtcolorwidgets-${QTCW_COMMIT:0:8}.tar.bz2"

LICENSE="Apache-2.0 Free-Art-1.3 GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE="wayland"

DEPEND="
	dev-libs/kdsingleapplication
	dev-qt/qtbase:6[dbus,gui,network,widgets]
	dev-qt/qtsvg:6
	sys-apps/dbus
	wayland? ( kde-frameworks/kguiaddons:6 )
"
RDEPEND="${DEPEND}"
BDEPEND="
	dev-qt/qttools:6[linguist]
"

src_prepare() {
	# bundles https://gitlab.com/mattbas/Qt-Color-Widgets ...
	mkdir external || die
	mv "${WORKDIR}"/Qt-Color-Widgets-${QTCW_COMMIT} external/Qt-Color-Widgets || die

	# safety
	sed -e "s/include(FetchContent)/# & # no we don't/" -i CMakeLists.txt || die

	cmake_src_prepare
}

src_configure() {
	# -Werror=strict-aliasing
	# https://bugs.gentoo.org/859613
	# https://github.com/flameshot-org/flameshot/issues/3531
	#
	# Do not trust with LTO either
	append-flags -fno-strict-aliasing
	filter-lto

	local mycmakeargs=(
		-DENABLE_CACHE=0
		-DDISABLE_UPDATE_CHECKER=ON
		-DUSE_KDSINGLEAPPLICATION=ON
		-DUSE_BUNDLED_KDSINGLEAPPLICATION=OFF
		-DQTCOLORWIDGETS_BUILD_STATIC_LIBS=ON
		-DUSE_WAYLAND_CLIPBOARD=$(usex wayland)
	)

	cmake_src_configure
}
