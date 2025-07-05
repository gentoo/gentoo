# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson xdg-utils

DESCRIPTION="GTK+ based CD and DVD burning application"
HOMEPAGE="
	https://docs.xfce.org/apps/xfburn/start
	https://gitlab.xfce.org/apps/xfburn/
"
SRC_URI="https://archive.xfce.org/src/apps/${PN}/${PV%.*}/${P}.tar.bz2"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 arm arm64 ~loong ppc ~ppc64 ~riscv x86"
IUSE="gstreamer +udev"

# TODO: remove exo when we dep on xfce >= 4.21
DEPEND="
	>=dev-libs/glib-2.66.0
	>=dev-libs/libburn-0.4.2:=
	>=dev-libs/libisofs-0.6.2:=
	>=x11-libs/gtk+-3.24.0:3
	>=xfce-base/exo-0.18.0:=
	>=xfce-base/libxfce4ui-4.18.0:=
	>=xfce-base/libxfce4util-4.18.0:=
	gstreamer? (
		>=media-libs/gstreamer-1.0.0:1.0
		>=media-libs/gst-plugins-base-1.0.0:1.0
	)
	udev? ( >=dev-libs/libgudev-145:= )
"
RDEPEND="
	${DEPEND}
"
BDEPEND="
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
"

src_configure() {
	local emesonargs=(
		$(meson_feature udev gudev)
		$(meson_feature gstreamer)
	)

	meson_src_configure
}

pkg_postinst() {
	xdg_icon_cache_update
	xdg_desktop_database_update
}

pkg_postrm() {
	xdg_icon_cache_update
	xdg_desktop_database_update
}
