# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PLOCALES="ar bn ca cs da de es et fi fr hi_IN hu is it ja kk ko lt lv nb nl nn pl pt_BR pt_PT ro ru sk sr sr@ijekavian sr@ijekavianlatin sr@latin sv tr uk zh_CN zh_TW"
inherit cmake-utils l10n systemd user

DESCRIPTION="Simple Desktop Display Manager"
HOMEPAGE="https://github.com/sddm/sddm"
SRC_URI="https://github.com/${PN}/${PN}/releases/download/v${PV}/${P}.tar.gz"
KEYWORDS="amd64 ~arm arm64 x86"

LICENSE="GPL-2+ MIT CC-BY-3.0 CC-BY-SA-3.0 public-domain"
SLOT="0"
IUSE="consolekit elogind +pam systemd test"

REQUIRED_USE="?? ( elogind systemd )"

RDEPEND="
	>=dev-qt/qtcore-5.9.4:5
	>=dev-qt/qtdbus-5.9.4:5
	>=dev-qt/qtdeclarative-5.9.4:5
	>=dev-qt/qtgui-5.9.4:5
	>=dev-qt/qtnetwork-5.9.4:5
	>=x11-base/xorg-server-1.15.1
	x11-libs/libxcb[xkb]
	consolekit? ( >=sys-auth/consolekit-0.9.4 )
	elogind? ( sys-auth/elogind )
	pam? ( sys-libs/pam )
	systemd? ( sys-apps/systemd:= )
	!systemd? ( sys-power/upower )"

DEPEND="${RDEPEND}
	dev-python/docutils
	>=dev-qt/linguist-tools-5.9.4:5
	kde-frameworks/extra-cmake-modules
	virtual/pkgconfig
	test? ( >=dev-qt/qttest-5.9.4:5 )"

PATCHES=(
	"${FILESDIR}/${PN}-0.12.0-respect-user-flags.patch" # fix for flags handling and bug 563108
	"${FILESDIR}/${P}-Xsession.patch" # bug 611210
	"${FILESDIR}/${P}-sddmconfdir.patch"
	# TODO: fix properly
	"${FILESDIR}/${PN}-0.16.0-ck2-revert.patch" # bug 633920
)

src_prepare() {
	cmake-utils_src_prepare

	disable_locale() {
		sed -e "/${1}\.ts/d" -i data/translations/CMakeLists.txt || die
	}
	l10n_find_plocales_changes "data/translations" "" ".ts"
	l10n_for_each_disabled_locale_do disable_locale

	if ! use test; then
		sed -e "/^find_package/s/ Test//" -i CMakeLists.txt || die
		cmake_comment_add_subdirectory test
	fi
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

src_install() {
	cmake-utils_src_install

	# Create a default.conf as upstream dropped /etc/sddm.conf w/o replacement
	local confd="/usr/share/sddm/sddm.conf.d"
	dodir ${confd}
	"${D}"/usr/bin/sddm --example-config > "${D}/${confd}"/00default.conf \
		|| die "Failed to create 00default.conf"
	sed -e "/^InputMethod/s/qtvirtualkeyboard//" \
		-i "${D}/${confd}"/00default.conf || die
}

pkg_postinst() {
	elog "Starting with 0.18.0, SDDM no longer installs /etc/sddm.conf"
	elog "Use it to override specific options. SDDM defaults are now"
	elog "found in: /usr/share/sddm/sddm.conf.d/00default.conf"

	enewgroup ${PN}
	enewuser ${PN} -1 -1 /var/lib/${PN} ${PN},video

	systemd_reenable sddm.service
}
