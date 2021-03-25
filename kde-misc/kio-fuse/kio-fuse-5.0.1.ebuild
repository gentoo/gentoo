# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

ECM_TEST="true"
KFMIN=5.74.0
QTMIN=5.15.2
inherit ecm kde.org linux-info

DESCRIPTION="FUSE interface for KIO"
HOMEPAGE="https://feverfew.home.blog/2019/12/24/kiofuse-beta-4-9-0-released/"

if [[ ${KDE_BUILD_TYPE} = release ]]; then
	SRC_URI="mirror://kde/stable/${PN}/${PV}/${P}.tar.xz"
	KEYWORDS="~amd64 ~arm64 ~ppc64 ~x86"
fi

LICENSE="GPL-3+"
SLOT="5"
IUSE=""

RESTRICT+=" test" # depend on fuse kernel module

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
