# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

KFMIN=6.18.0
QTMIN=6.9.1
inherit ecm flag-o-matic plasma.kde.org xdg

DESCRIPTION="Plasma applet and services for creating encrypted vaults"
HOMEPAGE+=" https://cukic.co/2017/02/03/vaults-encryption-in-plasma/"

LICENSE="LGPL-3"
SLOT="6"
KEYWORDS="amd64 arm64 ~loong ~ppc64 ~riscv ~x86"
IUSE="networkmanager"

DEPEND="
	>=dev-qt/qtbase-${QTMIN}:6[dbus,gui,widgets]
	>=dev-qt/qtdeclarative-${QTMIN}:6
	>=kde-frameworks/kcodecs-${KFMIN}:6
	>=kde-frameworks/kconfig-${KFMIN}:6
	>=kde-frameworks/kcoreaddons-${KFMIN}:6
	>=kde-frameworks/kdbusaddons-${KFMIN}:6
	>=kde-frameworks/ki18n-${KFMIN}:6
	>=kde-frameworks/kio-${KFMIN}:6
	>=kde-frameworks/kitemmodels-${KFMIN}:6
	>=kde-frameworks/kservice-${KFMIN}:6
	>=kde-plasma/libksysguard-${KDE_CATV}:6
	>=kde-plasma/libplasma-${KDE_CATV}:6
	>=kde-plasma/plasma-activities-${KDE_CATV}:6=
	networkmanager? ( >=kde-frameworks/networkmanager-qt-${KFMIN}:6 )
"
RDEPEND="${DEPEND}
	|| (
		>=app-crypt/gocryptfs-1.8
		>=sys-fs/cryfs-0.9.9
		>=sys-fs/encfs-1.9.2
	)
"

src_configure() {
	# ODR violations (bug #909446, kde#471836)
	filter-lto

	local mycmakeargs=(
		$(cmake_use_find_package networkmanager KF6NetworkManagerQt)
	)

	ecm_src_configure
}

pkg_postinst() {
	xdg_pkg_postinst

	local has_deprecated_backend
	dropping_backend() {
		if has_version ${2}; then
			elog "${CATEGORY}/${PN} will drop support for ${1} in the future."
			elog "Migrate away from any ${2} vaults before that happens."
			elog
			has_deprecated_backend=1
		fi
	}

	dropping_backend CryFS sys-fs/cryfs
	dropping_backend EncFS sys-fs/encfs

	if [[ has_deprecated_backend ]]; then
		elog "The only supported backend going forward will be app-crypt/gocryptfs."
		elog
		elog "See also:"
		elog "https://invent.kde.org/plasma/plasma-vault/-/merge_requests/57"
		elog "https://invent.kde.org/plasma/plasma-vault/-/merge_requests/62"
	fi
}
