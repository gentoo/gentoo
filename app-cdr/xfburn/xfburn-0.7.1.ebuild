# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit xdg-utils

DESCRIPTION="GTK+ based CD and DVD burning application"
HOMEPAGE="
	https://docs.xfce.org/apps/xfburn/start
	https://gitlab.xfce.org/apps/xfburn/
"
SRC_URI="https://archive.xfce.org/src/apps/${PN}/${PV%.*}/${P}.tar.bz2"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~ia64 ~loong ~ppc ~ppc64 ~riscv ~x86"
IUSE="gstreamer +udev"

DEPEND="
	>=dev-libs/glib-2.38
	>=dev-libs/libburn-0.4.2:=
	>=dev-libs/libisofs-0.6.2:=
	>=x11-libs/gtk+-3.20:3
	>=xfce-base/exo-0.11.0:=
	>=xfce-base/libxfce4ui-4.12.0:=
	gstreamer? (
		media-libs/gstreamer:1.0
		media-libs/gst-plugins-base:1.0
	)
	udev? ( dev-libs/libgudev:= )
"
RDEPEND="
	${DEPEND}
"
BDEPEND="
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
"

src_configure() {
	local myconf=(
		$(use_enable udev gudev)
		$(use_enable gstreamer)
	)

	econf "${myconf[@]}"
}

pkg_postinst() {
	xdg_icon_cache_update
	xdg_desktop_database_update
}

pkg_postrm() {
	xdg_icon_cache_update
	xdg_desktop_database_update
}
