# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_TEST="true"
KDE_ORG_COMMIT="46620338f6e1c21f2c29e14ccbb6a399c4cd209b"
KFMIN=5.82.0
QTMIN=5.15.5
inherit ecm kde.org linux-info tmpfiles

DESCRIPTION="FUSE interface for KIO"
HOMEPAGE="https://feverfew.home.blog/2019/12/24/kiofuse-beta-4-9-0-released/"

LICENSE="GPL-3+"
SLOT="5"
KEYWORDS="~amd64 ~arm ~arm64 ~loong ~ppc64 ~riscv ~x86"
IUSE=""

RESTRICT="test" # depend on fuse kernel module

DEPEND="
	>=dev-qt/qtdbus-${QTMIN}:5
	>=dev-qt/qtgui-${QTMIN}:5
	>=dev-qt/qtwidgets-${QTMIN}:5
	>=kde-frameworks/kcoreaddons-${KFMIN}:5
	>=kde-frameworks/ki18n-${KFMIN}:5
	>=kde-frameworks/kio-${KFMIN}:5
	sys-fs/fuse:3
"
RDEPEND="${DEPEND}"

pkg_setup() {
	local CONFIG_CHECK="~FUSE_FS"
	linux-info_pkg_setup

	ecm_pkg_setup
}

pkg_postinst() {
	tmpfiles_process "${PN}-tmpfiles.conf"
	ecm_pkg_postinst
}
