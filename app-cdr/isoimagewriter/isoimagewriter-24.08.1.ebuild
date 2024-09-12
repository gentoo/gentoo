# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

KFMIN=6.5.0
QTMIN=6.7.2
inherit ecm gear.kde.org

DESCRIPTION="Write hybrid ISO files onto a USB disk"
HOMEPAGE="https://community.kde.org/ISOImageWriter"

LICENSE="GPL-3"
SLOT="6"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~x86"
IUSE=""

DEPEND="
	>=app-crypt/gpgme-1.23.1-r1:=[cxx(+),qt6]
	>=dev-qt/qtbase-${QTMIN}:6[dbus,gui,network,widgets]
	>=kde-frameworks/karchive-${KFMIN}:6
	>=kde-frameworks/kcrash-${KFMIN}:6
	>=kde-frameworks/kcoreaddons-${KFMIN}:6
	>=kde-frameworks/ki18n-${KFMIN}:6
	>=kde-frameworks/kiconthemes-${KFMIN}:6
	>=kde-frameworks/solid-${KFMIN}:6
"
RDEPEND="${DEPEND}
	sys-fs/udisks:2
"
