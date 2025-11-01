# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PAM_TAR="${PN}-0.21.0-pam"
if [[ ${PV} == *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/${PN}/${PN}.git"
else
	COMMIT=662a409aabec39bdbff2a13fa008e6a7a873dca1
	SRC_URI="https://github.com/${PN}/${PN}/archive/${COMMIT}.tar.gz -> ${P}-${COMMIT:0:8}.tar.gz"
	S="${WORKDIR}/${PN}-${COMMIT}"
	KEYWORDS="~amd64 ~arm64 ~loong ~ppc64 ~riscv ~x86"
fi

QTMIN=6.7.2
inherit cmake linux-info pam systemd tmpfiles

DESCRIPTION="Simple Desktop Display Manager"
HOMEPAGE="https://github.com/sddm/sddm"
SRC_URI+=" https://dev.gentoo.org/~asturm/distfiles/${PAM_TAR}.tar.xz"

LICENSE="GPL-2+ MIT CC-BY-3.0 CC-BY-SA-3.0 public-domain"
SLOT="0"
IUSE="+elogind systemd test"

REQUIRED_USE="^^ ( elogind systemd )"
RESTRICT="!test? ( test )"

DEPEND="
	acct-group/sddm
	acct-user/sddm
	>=dev-qt/qtbase-${QTMIN}:6[dbus,gui,network]
	>=dev-qt/qtdeclarative-${QTMIN}:6
	sys-libs/pam
	x11-libs/libXau
	x11-libs/libxcb:=
	elogind? (
		sys-auth/elogind[pam]
		sys-power/upower
	)
	systemd? ( sys-apps/systemd:=[pam] )
"
RDEPEND="${DEPEND}
	gui-apps/sddm-gentoo-config
	!systemd? ( gui-libs/display-manager-init )
"
BDEPEND="
	dev-python/docutils
	>=dev-qt/qttools-${QTMIN}[linguist]
	kde-frameworks/extra-cmake-modules:0
	virtual/pkgconfig
"

PATCHES=(
	# Downstream patches
	"${FILESDIR}/${PN}-0.20.0-respect-user-flags.patch"
	"${FILESDIR}/${PN}-0.21.0_p20250310-Xsession-xinitrc.patch" # bug 611210
	"${FILESDIR}/${PN}-0.21.0_p20250310-set-XAUTHLOCALHOSTNAME.patch" # bug 913862, thx opensuse
	"${FILESDIR}/${P}-cmake-minreqver-3.16.patch" # bug 964439
)

pkg_setup() {
	local CONFIG_CHECK="~DRM"
	use kernel_linux && linux-info_pkg_setup
}

src_unpack() {
	[[ ${PV} == *9999* ]] && git-r3_src_unpack
	default
}

src_prepare() {
	cmake_src_prepare

	if ! use test; then
		sed -e "/^find_package/s/ Test//" -i CMakeLists.txt || die
		cmake_comment_add_subdirectory test
	fi

	if use systemd; then
		sed -e "/pam_elogind.so/s/elogind/systemd/" \
			-i "${WORKDIR}"/${PAM_TAR}/${PN}-greeter.pam || die
	fi
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_MAN_PAGES=ON
		-DBUILD_WITH_QT6=ON
		-DDBUS_CONFIG_FILENAME="org.freedesktop.sddm.conf"
		-DRUNTIME_DIR=/run/sddm
		-DSYSTEMD_TMPFILES_DIR="/usr/lib/tmpfiles.d"
		-DNO_SYSTEMD=$(usex !systemd)
		-DUSE_ELOGIND=$(usex elogind)
	)

	if use elogind; then
		mycmakeargs+=(
			# try to use VT7 first.
			# Keep the same as CHECKVT from display-manager
			-DSDDM_INITIAL_VT=7
		)
	fi

	cmake_src_configure
}

src_install() {
	cmake_src_install

	# with systemd logs are sent to journald, so no point to bother in that case
	if ! use systemd; then
		insinto /etc/logrotate.d
		newins "${FILESDIR}/sddm.logrotate" sddm
	fi

	newpamd "${WORKDIR}"/${PAM_TAR}/${PN}.pam ${PN}
	newpamd "${WORKDIR}"/${PAM_TAR}/${PN}-autologin.pam ${PN}-autologin
	newpamd "${WORKDIR}"/${PAM_TAR}/${PN}-greeter.pam ${PN}-greeter
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

	systemd_reenable sddm.service
}
