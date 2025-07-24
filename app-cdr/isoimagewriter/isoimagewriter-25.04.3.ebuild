# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

KFMIN=6.13.0
QTMIN=6.7.2
inherit ecm gear.kde.org xdg

DESCRIPTION="Write hybrid ISO files onto a USB disk"
HOMEPAGE="https://community.kde.org/ISOImageWriter"

LICENSE="GPL-3"
SLOT="6"
KEYWORDS="amd64 ~arm64 ~ppc64 ~x86"
IUSE=""

DEPEND="
	dev-cpp/gpgmepp:=
	dev-libs/qgpgme:=
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
