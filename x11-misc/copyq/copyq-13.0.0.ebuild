# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake optfeature virtualx xdg

DESCRIPTION="Clipboard manager with advanced features"
HOMEPAGE="https://hluk.github.io/CopyQ/ https://github.com/hluk/CopyQ/"
SRC_URI="https://github.com/hluk/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/CopyQ-${PV}"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE="notification test X"

RESTRICT="!test? ( test )"

RDEPEND="
	dev-libs/wayland
	dev-qt/qtbase:6[gui,network,widgets,xml(+)]
	dev-qt/qtdeclarative:6
	dev-qt/qtsvg:6
	dev-qt/qtwayland:6
	kde-frameworks/kguiaddons:6
	X? (
		dev-qt/qtbase:6=[X]
		x11-libs/libX11
		x11-libs/libXfixes
		x11-libs/libXtst
	)
	notification? (
		kde-frameworks/knotifications:6
		kde-frameworks/kstatusnotifieritem:6
	)
"
DEPEND="${RDEPEND}
	X? ( x11-base/xorg-proto )
"
BDEPEND="
	kde-frameworks/extra-cmake-modules:0
	dev-qt/qttools:6[linguist]
	dev-util/wayland-scanner
	test? (
		app-crypt/gnupg
		x11-wm/openbox
	)
"

PATCHES=(
	# used in tests
	"${FILESDIR}/${PN}-7.1.0-support-plugin-dir-envvar-r1.patch"
	"${FILESDIR}/${P}-fix-cmake-qt-6.10.patch" # bug #966739
)

src_configure() {
	local mycmakeargs=(
		-DPLUGIN_INSTALL_PREFIX="${EPREFIX}/usr/$(get_libdir)/${PN}/plugins"
		-DWITH_NATIVE_NOTIFICATIONS=$(usex notification)
		-DWITH_TESTS=$(usex test)
		-DWITH_X11=$(usex X)
	)

	cmake_src_configure
}

my_src_test() {
	# Don't rerun tests and more logs
	local -x COPYQ_TESTS_RERUN_FAILED=0
	local -x COPYQ_LOG_LEVEL=DEBUG

	# Skip test that require network
	local -x COPYQ_TESTS_NO_NETWORK=1

	# Less noise from trying the wayland plugin
	local -x QT_QPA_PLATFORM=xcb

	# Make sure copyq doesn't use system installed plugins which may be incompatible.
	local -x COPYQ_PLUGIN_DIR="${BUILD_DIR}/plugins"

	# In case the users current system confuses the notification integration
	unset KDE_FULL_SESSION XDG_CURRENT_DESKTOP

	mkdir "${HOME}"/.gnupg || die

	ebegin "Starting Openbox"
	openbox & # upstream uses Openbox and it doesn't fail like IceWM
	sleep 5
	eend 0

	"${BUILD_DIR}"/copyq tests
}

src_test() {
	# local -x QT_QPA_PLATFORM=offscreen # TODO: make it work
	virtx my_src_test
}

pkg_postinst() {
	xdg_pkg_postinst
	optfeature "encryption support" app-crypt/gnupg
}
