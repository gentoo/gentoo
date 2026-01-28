# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

KDE_ORG_NAME="kwallet"
QTMIN=6.10.1
inherit ecm frameworks.kde.org optfeature

DESCRIPTION="Framework providing desktop-wide storage for passwords"

LICENSE="LGPL-2+"
KEYWORDS="amd64 arm64 ~loong ppc64 ~riscv ~x86"
IUSE="gpg +man +keyring +legacy-kwallet X"

DEPEND="
	dev-libs/libgcrypt:0=
	>=dev-qt/qtbase-${QTMIN}:6[dbus,gui,widgets]
	=kde-frameworks/kcolorscheme-${KDE_CATV}*:6
	=kde-frameworks/kconfig-${KDE_CATV}*:6
	=kde-frameworks/kcoreaddons-${KDE_CATV}*:6
	=kde-frameworks/kcrash-${KDE_CATV}*:6
	=kde-frameworks/kdbusaddons-${KDE_CATV}*:6
	=kde-frameworks/ki18n-${KDE_CATV}*:6
	=kde-frameworks/knotifications-${KDE_CATV}*:6
	=kde-frameworks/kservice-${KDE_CATV}*:6
	=kde-frameworks/kwallet-${KDE_CATV}*:6
	=kde-frameworks/kwidgetsaddons-${KDE_CATV}*:6
	=kde-frameworks/kwindowsystem-${KDE_CATV}*:6[X?]
	gpg? ( dev-libs/qgpgme:= )
	keyring? ( >=app-crypt/qca-2.3.9:2[qt6(+)] )
	legacy-kwallet? ( app-crypt/libsecret )
"
RDEPEND="${DEPEND}
	!<kde-frameworks/kwallet-5.116.0-r2:5[-kf6compat(-)]
	!<kde-frameworks/kwallet-6.14.0:6
	keyring? ( =kde-frameworks/ksecretd-services-${KDE_CATV}* )
"
BDEPEND="man? ( >=kde-frameworks/kdoctools-${KDE_CATV}:6 )"

PATCHES=( "${FILESDIR}/${PN}-6.14.0-stdalone.patch" )

src_prepare() {
	ecm_src_prepare
	cmake_comment_add_subdirectory -f src api
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_KWALLET_QUERY=ON # could be split easily together w/ docs
		$(cmake_use_find_package gpg Gpgmepp)
		-DBUILD_KSECRETD=$(usex keyring)
		-DBUILD_KWALLETD=$(usex legacy-kwallet)
		$(cmake_use_find_package man KF6DocTools)
		-DWITH_X11=$(usex X)
	)

	ecm_src_configure
}

src_install() {
	ecm_src_install

	# provided by kde-frameworks/ksecretd-services
	if use keyring; then
		rm -v "${ED}"/usr/share/dbus-1/services/org.freedesktop.impl.portal.desktop.kwallet.service \
			"${ED}"/usr/share/dbus-1/services/org.kde.secretservicecompat.service || die
	fi
}

pkg_postinst() {
	if [[ -z "${REPLACING_VERSIONS}" ]]; then
		optfeature "Auto-unlocking after Plasma login" "kde-plasma/kwallet-pam"
		optfeature "KWallet management" "kde-apps/kwalletmanager"
		elog "For more information, read https://wiki.gentoo.org/wiki/KDE#KWallet"
	fi
}
