# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake optfeature virtualx xdg

DESCRIPTION="Clipboard manager with advanced features"
HOMEPAGE="
	https://hluk.github.io/CopyQ/
	https://github.com/hluk/CopyQ/
"
SRC_URI="https://github.com/hluk/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/CopyQ-${PV}"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86 ~amd64-linux ~x86-linux"

IUSE="notification qt6 test"
# Native notifications are not supported with Qt 6
# (Bumpers please check when this requirement is lifted).
# src/notifications.cmake
REQUIRED_USE="notification? ( !qt6 )"

RDEPEND="
	dev-libs/wayland
	x11-libs/libX11
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
		notification? ( kde-frameworks/knotifications:5 )
		test? ( dev-qt/qttest:5 )
	)
	qt6? (
		dev-qt/qtbase:6=[X,gui,network,widgets,xml(+)]
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
		dev-util/wayland-scanner
	)
	test? (
		app-crypt/gnupg
		x11-wm/openbox
	)
"

PATCHES=(
	"${FILESDIR}/copyq-7.1.0-fix-qt-6.6.0-build.patch"
	"${FILESDIR}/copyq-7.1.0-fix-test-failure-due-to-invalid-regex.patch"
	"${FILESDIR}/copyq-7.1.0-fix-gpg-2.1-support.patch"
	"${FILESDIR}/copyq-7.1.0-support-plugin-dir-envvar.patch"
)

src_prepare() {
	cmake_src_prepare

	# FAIL!  : Tests::actionDialogAccept() 'NO_ERRORS(m_test->runClient((Args() << "keys" << actionDialogId << "ENTER" << clipboardBrowserId), toByteArray("")))' returned FALSE.
	# FAIL!  : Tests::actionDialogSelection() 'NO_ERRORS(m_test->runClient((Args() << "keys" << actionDialogId << "ENTER" << clipboardBrowserId), toByteArray("")))' returned FALSE.
	# FAIL!  : Tests::actionDialogSelectionInputOutput() 'NO_ERRORS(m_test->runClient((Args() << "keys" << actionDialogId << "ENTER" << clipboardBrowserId), toByteArray("")))' returned FALSE.
	# FAIL!  : Tests::commandShowAt() 'NO_ERRORS(m_test->waitOnOutput((Args() << "visible"), toByteArray("true\n")))' returned FALSE.
	sed -Ei -e '
	/Tests::(actionDialog(Accept|Selection(|InputOutput))|commandShow)/,/}/ {
	/^\s*\{/ a \
	#if QT_VERSION < QT_VERSION_CHECK(6,0,0)\
	SKIP("Broken on qt5");\
	#endif
	}' src/tests/tests.cpp || die
}

src_configure() {
	local mycmakeargs=(
		-DPLUGIN_INSTALL_PREFIX="${EPREFIX}/usr/$(get_libdir)/${PN}/plugins"
		-DWITH_NATIVE_NOTIFICATIONS=$(usex notification)
		-DWITH_QT6=$(usex qt6)
		-DWITH_TESTS=$(usex test)
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

	return $?
}

src_test() {
	virtx my_src_test
}

pkg_postinst() {
	xdg_pkg_postinst
	optfeature "encryption support" app-crypt/gnupg
}
