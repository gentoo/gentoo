# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake edo optfeature virtualx xdg

DESCRIPTION="Clipboard manager with advanced features"
HOMEPAGE="https://github.com/hluk/CopyQ"
SRC_URI="https://github.com/hluk/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/CopyQ-${PV}"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="debug kde qt6 test"
RESTRICT="test"

RDEPEND="
	dev-libs/wayland
	x11-libs/libX11
	x11-libs/libXfixes
	x11-libs/libXtst
	!qt6? (
		dev-qt/qtcore:5
		dev-qt/qtdeclarative:5
		dev-qt/qtgui:5
		dev-qt/qtnetwork:5
		dev-qt/qtsvg:5
		dev-qt/qtwayland:5
		dev-qt/qtwidgets:5
		dev-qt/qtx11extras:5
		dev-qt/qtxml:5
		kde? ( kde-frameworks/knotifications:5 )
		test? ( dev-qt/qttest:5 )
	)
	qt6? (
		dev-qt/qtbase:6=[X,gui,network,test?,widgets,xml(+)]
		dev-qt/qtdeclarative:6
		dev-qt/qtsvg:6
		dev-qt/qtwayland:6
	)
"
DEPEND="${RDEPEND}
	x11-base/xorg-proto
"
BDEPEND="
	kde-frameworks/extra-cmake-modules:0
	!qt6? (
		dev-qt/linguist-tools:5
		dev-qt/qtwaylandscanner:5
	)
	qt6? (
		dev-qt/qttools:6[linguist]
		dev-qt/qtwayland:6
		dev-util/wayland-scanner
	)
	test? (
		app-crypt/gnupg
		x11-wm/icewm
	)
"

src_configure() {
	if use debug; then
		# Add debug definitions
		CMAKE_BUILD_TYPE="Debug"
	fi

	local mycmakeargs=(
		-DPLUGIN_INSTALL_PREFIX="${EPREFIX}/usr/$(get_libdir)/${PN}/plugins"
		-DWITH_NATIVE_NOTIFICATIONS=$(usex kde)
		-DWITH_QT6=$(usex qt6)
		-DWITH_TESTS=$(usex test)
	)

	cmake_src_configure
}

my_src_test() {
	local -x COPYQ_TESTS_RERUN_FAILED=0
	local -x COPYQ_TESTS_NO_NETWORK=1

	ebegin "Starting IceWM"
	icewm &
	sleep 5
	eend 0

	cd "${BUILD_DIR}" || die
	mkdir -p "${HOME}"/.gnupg || die

	# ScriptError: Failed to send key presses
	edo ./copyq tests
}

src_test() {
	virtx my_src_test
}

pkg_postinst() {
	xdg_pkg_postinst
	optfeature "encryption support" app-crypt/gnupg
}
