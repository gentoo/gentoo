# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PLOCALES="ar bn ca cs da de es et fi fr hi_IN hu is it ja kk ko lt lv nb nl nn pl pt_BR pt_PT ro ru sk sr sr@ijekavian sr@ijekavianlatin sr@latin sv tr uk zh_CN zh_TW"
inherit cmake plocale systemd tmpfiles

DESCRIPTION="Simple Desktop Display Manager"
HOMEPAGE="https://github.com/sddm/sddm"
SRC_URI="https://github.com/${PN}/${PN}/releases/download/v${PV}/${P}.tar.xz"

LICENSE="GPL-2+ MIT CC-BY-3.0 CC-BY-SA-3.0 public-domain"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~riscv ~x86"
IUSE="elogind +pam systemd test"
RESTRICT="!test? ( test )"

REQUIRED_USE="?? ( elogind systemd )"

BDEPEND="
	dev-python/docutils
	>=dev-qt/linguist-tools-5.9.4:5
	kde-frameworks/extra-cmake-modules:5
	virtual/pkgconfig
"
RDEPEND="
	acct-group/sddm
	acct-user/sddm
	>=dev-qt/qtcore-5.9.4:5
	>=dev-qt/qtdbus-5.9.4:5
	>=dev-qt/qtdeclarative-5.9.4:5
	>=dev-qt/qtgui-5.9.4:5
	>=dev-qt/qtnetwork-5.9.4:5
	>=x11-base/xorg-server-1.15.1
	x11-libs/libxcb[xkb]
	elogind? ( sys-auth/elogind )
	pam? ( sys-libs/pam )
	!pam? ( virtual/libcrypt:= )
	systemd? ( sys-apps/systemd:= )
	!systemd? ( sys-power/upower )
"
DEPEND="${RDEPEND}
	test? ( >=dev-qt/qttest-5.9.4:5 )
"

PATCHES=(
	"${FILESDIR}/${P}-respect-user-flags.patch"
	"${FILESDIR}/${P}-Xsession.patch" # bug 611210
	"${FILESDIR}/${PN}-0.18.0-sddmconfdir.patch"
	# fix for groups: https://github.com/sddm/sddm/issues/1159
	"${FILESDIR}/${P}-revert-honor-PAM-supplemental-groups.patch"
	"${FILESDIR}/${P}-honor-PAM-supplemental-groups-v2.patch"
	# fix for ReuseSession=true
	"${FILESDIR}/${P}-only-reuse-online-sessions.patch"
	# TODO: fix properly
	"${FILESDIR}/pam-1.4-substack.patch"
	# upstream git develop branch:
	"${FILESDIR}/${P}-qt-5.15.2.patch"
	"${FILESDIR}/${P}-cve-2020-28049.patch" # bug 753104
)

src_prepare() {
	cmake_src_prepare

	disable_locale() {
		sed -e "/${1}\.ts/d" -i data/translations/CMakeLists.txt || die
	}
	plocale_find_changes "data/translations" "" ".ts"
	plocale_for_each_disabled_locale disable_locale

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
	cmake_src_configure
}

src_install() {
	cmake_src_install

	newtmpfiles "${FILESDIR}/${PN}.tmpfiles" "${PN}.conf"

	# Create a default.conf as upstream dropped /etc/sddm.conf w/o replacement
	local confd="/usr/share/sddm/sddm.conf.d"
	dodir ${confd}
	"${D}"/usr/bin/sddm --example-config > "${D}/${confd}"/00default.conf \
		|| die "Failed to create 00default.conf"

	sed -e "/^InputMethod/s/qtvirtualkeyboard//" \
		-e "/^ReuseSession/s/false/true/" \
		-e "/^EnableHiDPI/s/false/true/" \
		-i "${D}/${confd}"/00default.conf || die
}

pkg_postinst() {
	tmpfiles_process "${PN}.conf"

	elog "Starting with 0.18.0, SDDM no longer installs /etc/sddm.conf"
	elog "Use it to override specific options. SDDM defaults are now"
	elog "found in: /usr/share/sddm/sddm.conf.d/00default.conf"

	systemd_reenable sddm.service
}
