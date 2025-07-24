# Copyright 2023-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

KFMIN=6.13.0
QTMIN=6.7.2
inherit ecm gear.kde.org xdg

DESCRIPTION="Convergent podcast application for desktop and mobile"
HOMEPAGE="https://apps.kde.org/kasts/"

LICENSE="GPL-2 GPL-2+ GPL-3+ BSD LGPL-3+"
SLOT="0"
KEYWORDS="amd64 ~arm64 ~ppc64 ~riscv ~x86"
IUSE="gstreamer vlc"

DEPEND="
	>=dev-libs/kirigami-addons-1.6.0:6
	>=dev-libs/qtkeychain-0.14.2:=[qt6(+)]
	>=dev-qt/qtbase-${QTMIN}:6[dbus,gui,network,sql,widgets,xml]
	>=dev-qt/qtdeclarative-${QTMIN}:6
	>=dev-qt/qtmultimedia-${QTMIN}:6
	>=dev-qt/qtsvg-${QTMIN}:6
	>=kde-frameworks/breeze-icons-${KFMIN}:6
	>=kde-frameworks/kconfig-${KFMIN}:6
	>=kde-frameworks/kcoreaddons-${KFMIN}:6
	>=kde-frameworks/kcrash-${KFMIN}:6
	>=kde-frameworks/kdbusaddons-${KFMIN}:6
	>=kde-frameworks/ki18n-${KFMIN}:6
	>=kde-frameworks/kiconthemes-${KFMIN}:6
	>=kde-frameworks/kirigami-${KFMIN}:6
	>=kde-frameworks/kwindowsystem-${KFMIN}:6
	>=kde-frameworks/syndication-${KFMIN}:6
	>=kde-frameworks/threadweaver-${KFMIN}:6
	media-libs/taglib:=
	gstreamer? (
		dev-libs/glib:2
		media-libs/gstreamer:1.0
		media-libs/gst-plugins-good:1.0
	)
	vlc? ( media-video/vlc:= )
"
RDEPEND="${DEPEND}"
BDEPEND="gstreamer? ( virtual/pkgconfig )"

src_configure() {
	local mycmakeargs=(
		-DBUILD_EXAMPLE_PLAYER=OFF
		-DBUILD_GSTREAMER_BACKEND=$(usex gstreamer)
		$(cmake_use_find_package vlc LIBVLC)
	)
	ecm_src_configure
}
