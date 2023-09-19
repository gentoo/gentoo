# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

if [[ ${PV} == *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/${PN}/${PN}.git"
else
	SRC_URI="https://github.com/${PN}/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="amd64 ~arm arm64 ~loong ~ppc64 ~riscv x86"
fi

QTMIN=5.15.2
inherit cmake linux-info optfeature systemd tmpfiles

DESCRIPTION="Simple Desktop Display Manager"
HOMEPAGE="https://github.com/sddm/sddm"

LICENSE="GPL-2+ MIT CC-BY-3.0 CC-BY-SA-3.0 public-domain"
SLOT="0"
IUSE="+elogind systemd test"

REQUIRED_USE="^^ ( elogind systemd )"
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
	x11-base/xorg-server
	!systemd? ( gui-libs/display-manager-init )
"
BDEPEND="
	dev-python/docutils
	>=dev-qt/linguist-tools-${QTMIN}:5
	kde-frameworks/extra-cmake-modules:5
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

	optfeature "Weston DisplayServer support (EXPERIMENTAL)" dev-libs/weston
	optfeature "KWin DisplayServer support (EXPERIMENTAL)" kde-plasma/kwin

	systemd_reenable sddm.service
}
