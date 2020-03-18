# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

ECM_HANDBOOK_DIR="docbook"
ECM_HANDBOOK="forceoptional"
KFMIN=5.60.0
QTMIN=5.12.3
inherit ecm

DESCRIPTION="GUI front end for Linux LVM2 and GNU parted based on KDE Frameworks"
HOMEPAGE="https://sourceforge.net/projects/kvpm/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="5"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="
	>=dev-qt/qtgui-${QTMIN}:5
	>=dev-qt/qtwidgets-${QTMIN}:5
	>=kde-frameworks/kconfig-${KFMIN}:5
	>=kde-frameworks/kconfigwidgets-${KFMIN}:5
	>=kde-frameworks/kcoreaddons-${KFMIN}:5
	>=kde-frameworks/ki18n-${KFMIN}:5
	>=kde-frameworks/kdelibs4support-${KFMIN}:5
	>=kde-frameworks/kwidgetsaddons-${KFMIN}:5
	>=kde-frameworks/kxmlgui-${KFMIN}:5
	sys-apps/util-linux
	>=sys-block/parted-2.3
	>=sys-fs/lvm2-2.02.120
"
RDEPEND="${DEPEND}
	!sys-block/kvpm:4
"

PATCHES=( "${FILESDIR}/${PN}-0.9.9-glibc-sysmacros.patch" )
