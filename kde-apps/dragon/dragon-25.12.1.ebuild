# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

KFMIN=6.19.0
QTMIN=6.9.1
inherit ecm gear.kde.org xdg

DESCRIPTION="Simple video player"
HOMEPAGE="https://apps.kde.org/dragonplayer/"

LICENSE="GPL-2+ || ( GPL-2 GPL-3 )"
SLOT="6"
KEYWORDS="~amd64 ~arm64 ~loong ~ppc64 ~riscv ~x86"
IUSE=""

# Upstream only supports the ffmpeg backend https://bugs.kde.org/show_bug.cgi?id=506940
DEPEND="
	>=dev-qt/qtbase-${QTMIN}:6[dbus,gui]
	>=dev-qt/qtdeclarative-${QTMIN}:6
	>=dev-qt/qtmultimedia-${QTMIN}:6[ffmpeg]
	>=kde-frameworks/kconfig-${KFMIN}:6
	>=kde-frameworks/kcoreaddons-${KFMIN}:6
	>=kde-frameworks/kcrash-${KFMIN}:6
	>=kde-frameworks/ki18n-${KFMIN}:6
	>=kde-frameworks/kio-${KFMIN}:6
	>=kde-frameworks/kirigami-${KFMIN}:6
	>=kde-frameworks/kservice-${KFMIN}:6
	>=kde-frameworks/kwindowsystem-${KFMIN}:6[wayland]
	media-video/ffmpeg:=
"
RDEPEND="${DEPEND}"
BDEPEND="sys-devel/gettext"
