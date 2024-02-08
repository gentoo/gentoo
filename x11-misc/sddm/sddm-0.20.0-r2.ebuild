# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

if [[ ${PV} == *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/${PN}/${PN}.git"
else
	SRC_URI="https://github.com/${PN}/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~arm ~arm64 ~loong ~ppc64 ~riscv x86"
fi

QTMIN=5.15.2
inherit cmake linux-info optfeature systemd tmpfiles

DESCRIPTION="Simple Desktop Display Manager"
HOMEPAGE="https://github.com/sddm/sddm"

LICENSE="GPL-2+ MIT CC-BY-3.0 CC-BY-SA-3.0 public-domain"
SLOT="0"
IUSE="+elogind systemd test X wayland kde"

REQUIRED_USE="^^ ( elogind systemd ) || ( X wayland )"
RESTRICT="!test? ( test )"

COMMON_DEPEND="
	acct-group/sddm
	acct-user/sddm
	>=dev-qt/qtcore-${QTMIN}:5
	>=dev-qt/qtdbus-${QTMIN}:5
	>=dev-qt/qtdeclarative-${QTMIN}:5
	>=dev-qt/qtgui-${QTMIN}:5
	>=dev-qt/qtnetwork-${QTMIN}:5
	sys-libs/pam
	x11-libs/libXau
	x11-libs/libxcb:=
	elogind? ( sys-auth/elogind[pam] )
	systemd? ( sys-apps/systemd:=[pam] )
	!systemd? ( sys-power/upower )
"
DEPEND="${COMMON_DEPEND}
	test? ( >=dev-qt/qttest-${QTMIN}:5 )
"
RDEPEND="${COMMON_DEPEND}
	X? ( x11-base/xorg-server )
	wayland? (
		kde? ( kde-plasma/kwin )
		!kde? ( dev-libs/weston[fullscreen] )
	)
	!systemd? ( gui-libs/display-manager-init )
"
BDEPEND="
	dev-python/docutils
	>=dev-qt/linguist-tools-${QTMIN}:5
	kde-frameworks/extra-cmake-modules:0
	virtual/pkgconfig
"

PATCHES=(
	# Downstream patches
	"${FILESDIR}/${P}-respect-user-flags.patch"
	"${FILESDIR}/${PN}-0.18.1-Xsession.patch" # bug 611210
	"${FILESDIR}/${P}-sddm.pam-use-substack.patch" # bug 728550
	"${FILESDIR}/${P}-disable-etc-debian-check.patch"
	"${FILESDIR}/${P}-no-default-pam_systemd-module.patch" # bug 669980
	# git master
	"${FILESDIR}/${P}-fix-use-development-sessions.patch"
	"${FILESDIR}/${P}-greeter-platform-detection.patch"
	"${FILESDIR}/${P}-no-qtvirtualkeyboard-on-wayland.patch"
	"${FILESDIR}/${P}-dbus-policy-in-usr.patch"
)

pkg_setup() {
	local CONFIG_CHECK="~DRM"
	use kernel_linux && linux-info_pkg_setup
}

src_prepare() {
	touch 01gentoo.conf || die
	touch sddm-02wayland-kwin.conf || die
	touch sddm-02wayland-weston.conf || die

cat <<-EOF >> 01gentoo.conf || die
[General]
# Remove qtvirtualkeyboard as InputMethod default
InputMethod=
EOF

cat <<-EOF >> sddm-02wayland-kwin.conf || die
#This file set SDDM to use wayland backend (kwin)

[General]
DisplayServer=wayland
GreeterEnvironment=QT_WAYLAND_SHELL_INTEGRATION=layer-shell

[Wayland]
CompositorCommand=kwin_wayland --drm --no-lockscreen --no-global-shortcuts --locale1
EOF

cat <<-EOF >> sddm-02wayland-weston.conf || die
# This file set SDDM to use wayland backend (weston)

[General]
DisplayServer=wayland

[Wayland]
CompositorCommand=weston --shell=fullscreen-shell.so
EOF

	cmake_src_prepare

	if ! use test; then
		sed -e "/^find_package/s/ Test//" -i CMakeLists.txt || die
		cmake_comment_add_subdirectory test
	fi
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_MAN_PAGES=ON
		-DDBUS_CONFIG_FILENAME="org.freedesktop.sddm.conf"
		-DRUNTIME_DIR=/run/sddm
		-DSYSTEMD_TMPFILES_DIR="/usr/lib/tmpfiles.d"
		-DNO_SYSTEMD=$(usex !systemd)
		-DUSE_ELOGIND=$(usex elogind)
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install

	insinto /etc/sddm.conf.d/
	doins "${S}"/01gentoo.conf
	if use wayland || use X; then
		if use kde; then
			newins "${S}"/sddm-02wayland-kwin.conf 02-wayland.conf
		else
			newins "${S}"/sddm-02wayland-weston.conf 02-wayland.conf
		fi
	fi
}

pkg_postinst() {
	tmpfiles_process "${PN}.conf"

	elog "NOTE: If SDDM startup appears to hang then entropy pool is too low."
	elog "This can be fixed by configuring one of the following:"
	elog "  - Enable CONFIG_RANDOM_TRUST_CPU in linux kernel"
	elog "  - # emerge sys-apps/haveged && rc-update add haveged boot"
	elog "  - # emerge sys-apps/rng-tools && rc-update add rngd boot"
	elog
	elog "SDDM example config can be shown with:"
	elog "  ${EROOT}/usr/bin/sddm --example-config"
	elog "Use ${EROOT}/etc/sddm.conf.d/ directory to override specific options."
	elog
	elog "For more information on how to configure SDDM, please visit the wiki:"
	elog "  https://wiki.gentoo.org/wiki/SDDM"
	if has_version x11-drivers/nvidia-drivers; then
		elog
		elog "  Nvidia GPU owners in particular should pay attention"
		elog "  to the troubleshooting section."
	fi
	elos ""
	elog "For experimental Wayland support, users should enable the wayland USE flag."
	elog "An 02wayland.conf file will be created setting wayland as sddm's display server"
	elog "If the kde USE flag is also enabled the compositor will be set to KWin, otherwise"
	elog "it is set to weston"
	elog ""
	elog "If both the X and wayland useflag are enabled, no configuration files are installed"
	elog "and therefore manual configuration is required."

	systemd_reenable sddm.service
}
