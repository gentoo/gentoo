# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_TEST="true"
KFMIN=6.3.0
QTMIN=6.6.2
inherit ecm kde.org linux-info tmpfiles

DESCRIPTION="FUSE interface for KIO"
HOMEPAGE="https://feverfew.home.blog/2019/12/24/kiofuse-beta-4-9-0-released/"

if [[ ${KDE_BUILD_TYPE} = release ]]; then
	SRC_URI="mirror://kde/stable/${PN}/${P}.tar.xz"
	KEYWORDS="~amd64 ~arm64 ~riscv"
fi

LICENSE="GPL-3+"
SLOT="6"
IUSE=""

RESTRICT="test" # depend on fuse kernel module

DEPEND="
	>=dev-qt/qtbase-${QTMIN}:6[dbus,gui,widgets]
	>=kde-frameworks/kcoreaddons-${KFMIN}:6
	>=kde-frameworks/ki18n-${KFMIN}:6
	>=kde-frameworks/kio-${KFMIN}:6
	sys-fs/fuse:3
"
RDEPEND="${DEPEND}
	!${CATEGORY}/${PN}:5
"

pkg_setup() {
	local CONFIG_CHECK="~FUSE_FS"
	linux-info_pkg_setup

	ecm_pkg_setup
}

pkg_postinst() {
	tmpfiles_process "${PN}-tmpfiles.conf"
	ecm_pkg_postinst
}
