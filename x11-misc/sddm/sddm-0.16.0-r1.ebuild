# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils systemd user

DESCRIPTION="Simple Desktop Display Manager"
HOMEPAGE="https://github.com/sddm/sddm"
SRC_URI="https://github.com/${PN}/${PN}/releases/download/v${PV}/${P}.tar.gz"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"

LICENSE="GPL-2+ MIT CC-BY-3.0 CC-BY-SA-3.0 public-domain"
SLOT="0"
IUSE="consolekit elogind +pam systemd"

REQUIRED_USE="?? ( elogind systemd )"

RDEPEND="
	>=dev-qt/qtcore-5.6:5
	>=dev-qt/qtdbus-5.6:5
	>=dev-qt/qtgui-5.6:5
	>=dev-qt/qtdeclarative-5.6:5
	>=dev-qt/qtnetwork-5.6:5
	>=x11-base/xorg-server-1.15.1
	x11-libs/libxcb[xkb]
	consolekit? ( >=sys-auth/consolekit-0.9.4 )
	elogind? ( sys-auth/elogind )
	pam? ( sys-libs/pam )
	systemd? ( sys-apps/systemd:= )
	!systemd? ( sys-power/upower )"

DEPEND="${RDEPEND}
	dev-python/docutils
	>=dev-qt/linguist-tools-5.6:5
	>=dev-qt/qttest-5.6:5
	kde-frameworks/extra-cmake-modules
	virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}/${PN}-0.12.0-respect-user-flags.patch" # fix for flags handling and bug 563108
	use consolekit && "${FILESDIR}/${P}-ck2-revert.patch" #bug 633920
)

src_prepare() {
	use consolekit && eapply "${FILESDIR}/${PN}-0.14.0-consolekit.patch"
	cmake-utils_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DENABLE_PAM=$(usex pam)
		-DNO_SYSTEMD=$(usex '!systemd')
		-DUSE_ELOGIND=$(usex 'elogind')
		-DBUILD_MAN_PAGES=ON
		-DDBUS_CONFIG_FILENAME="org.freedesktop.sddm.conf"
	)
	cmake-utils_src_configure
}

pkg_postinst() {
	enewgroup ${PN}
	enewuser ${PN} -1 -1 /var/lib/${PN} ${PN},video

	systemd_reenable sddm.service
}
