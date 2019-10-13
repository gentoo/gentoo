# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit gnome2-utils xdg-utils

DESCRIPTION="GTK+ based CD and DVD burning application"
HOMEPAGE="https://goodies.xfce.org/projects/applications/xfburn"
SRC_URI="https://archive.xfce.org/src/apps/${PN}/${PV%.*}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 arm ~ppc x86"
IUSE="gstreamer +udev"

RDEPEND=">=dev-libs/glib-2.32:=
	>=dev-libs/libburn-0.4.2:=
	>=dev-libs/libisofs-0.6.2:=
	>=x11-libs/gtk+-2.24:2=
	xfce-base/exo[gtk2(+)]
	>=xfce-base/libxfce4ui-4.10:=[gtk2(+)]
	gstreamer? (
		media-libs/gstreamer:1.0=
		media-libs/gst-plugins-base:1.0= )
	udev? ( virtual/libgudev:= )"
DEPEND="${RDEPEND}
	dev-util/intltool
	sys-devel/gettext
	virtual/pkgconfig"

src_configure() {
	local myconf=(
		$(use_enable udev gudev)
		$(use_enable gstreamer)
	)

	econf "${myconf[@]}"
}

pkg_postinst() {
	gnome2_icon_cache_update
	xdg_desktop_database_update
}

pkg_postrm() {
	gnome2_icon_cache_update
	xdg_desktop_database_update
}
