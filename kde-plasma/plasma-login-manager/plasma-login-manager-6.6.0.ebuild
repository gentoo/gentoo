# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

KFMIN=6.22.0
QTMIN=6.10.0
inherit ecm plasma.kde.org linux-info pam tmpfiles

DESCRIPTION="Plasma Login Manager"
HOMEPAGE="https://invent.kde.org/plasma/plasma-login-manager"

LICENSE="GPL-2+ MIT CC-BY-3.0 CC-BY-SA-3.0 public-domain"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"
RESTRICT="!test? ( test )"

DEPEND="
	>=dev-qt/qtbase-${QTMIN}:6[dbus,gui,network]
	>=dev-qt/qtdeclarative-${QTMIN}:6
	>=kde-frameworks/kauth-${KFMIN}:6
	>=kde-frameworks/kcmutils-${KFMIN}:6
	>=kde-frameworks/kconfig-${KFMIN}:6
	>=kde-frameworks/kdbusaddons-${KFMIN}:6
	>=kde-frameworks/ki18n-${KFMIN}:6
	>=kde-frameworks/kio-6.22.1:6
	>=kde-frameworks/kpackage-${KFMIN}:6
	>=kde-frameworks/kwindowsystem-${KFMIN}:6
	>=kde-plasma/plasma-workspace-${KDE_CATV}:6
	>=kde-plasma/layer-shell-qt-${KDE_CATV}:6
	>=kde-plasma/libplasma-${KDE_CATV}:6
	sys-apps/systemd:=[pam]
	sys-libs/pam
	x11-libs/libXau
"
RDEPEND="
	${DEPEND}
	acct-user/plasmalogin
"
BDEPEND="
	dev-python/docutils
	>=dev-build/cmake-3.25.0
	>=dev-qt/qttools-${QTMIN}[linguist]
	kde-frameworks/extra-cmake-modules:0
	virtual/pkgconfig
"

pkg_setup() {
	local CONFIG_CHECK="~DRM"
	use kernel_linux && linux-info_pkg_setup
}

src_prepare() {
	touch 01gentoo.conf || die

	cat <<-EOF >> 01gentoo.conf
	[General]
	# Remove qtvirtualkeyboard as InputMethod default
	InputMethod=
	EOF

	cmake_src_prepare

	if ! use test; then
		sed -e "/^find_package/s/ Test//" -i CMakeLists.txt || die
		cmake_comment_add_subdirectory test
	fi
}

src_configure() {
	local mycmakeargs=(
		-DRUNTIME_DIR=/run/plasmalogin

		# We install our own, our layout isn't in the upstream repo
		-DINSTALL_PAM_CONFIGURATION=OFF
		# If non-systemd compat ever arrives, we can try 7
		# again to be in sync with CHECKVT from display-manager,
		# but until then, stick with upstream default of 1.
		#-DPLASMALOGIN_INITIAL_VT=7
	)

	cmake_src_configure
}

src_install() {
	cmake_src_install

	insinto /etc/plasmalogin.conf.d/
	doins "${S}"/01gentoo.conf

	newpamd "${FILESDIR}"/plasmalogin.pam plasmalogin
	newpamd "${FILESDIR}"/plasmalogin-autologin.pam plasmalogin-autologin
	newpamd "${FILESDIR}"/plasmalogin-greeter.pam plasmalogin-greeter
}

pkg_postinst() {
	tmpfiles_process plasmalogin.conf
}
