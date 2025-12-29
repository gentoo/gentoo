# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson xdg-utils

DESCRIPTION="A thumbnail service for Thunar"
HOMEPAGE="
	https://docs.xfce.org/xfce/tumbler/start
	https://gitlab.xfce.org/xfce/tumbler/
"
SRC_URI="https://archive.xfce.org/src/xfce/${PN}/${PV%.*}/${P}.tar.xz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~loong ~ppc ~ppc64 ~riscv ~sparc ~x86"
IUSE="curl epub ffmpeg gstreamer gtk-doc jpeg odf pdf raw"

DEPEND="
	>=dev-libs/glib-2.72.0
	>=media-libs/freetype-2.0.0:2=
	>=media-libs/libpng-1.6.0:0=
	>=sys-apps/dbus-1.6
	>=xfce-base/libxfce4util-4.17.1:=
	>=x11-libs/gdk-pixbuf-2.42.8
	curl? ( >=net-misc/curl-7.32.0:= )
	epub? ( >=app-text/libgepub-0.6.0 )
	ffmpeg? ( >=media-video/ffmpegthumbnailer-2.2.2:= )
	gstreamer? (
		media-libs/gstreamer:1.0
		media-libs/gst-plugins-base:1.0
	)
	jpeg? ( >=media-libs/libjpeg-turbo-2.0.0:0= )
	odf? ( >=gnome-extra/libgsf-1.14.9:= )
	pdf? ( >=app-text/poppler-0.82.0[cairo] )
	raw? ( >=media-libs/libopenraw-0.1.0:=[gtk] )
"
RDEPEND="
	${DEPEND}
	gstreamer? ( media-plugins/gst-plugins-meta:1.0 )
"
BDEPEND="
	dev-build/xfce4-dev-tools
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
	gtk-doc? ( dev-util/gtk-doc )
"

src_configure() {
	local emesonargs=(
		$(meson_use gtk-doc)
		$(meson_feature curl cover-thumbnailer)
		-Ddesktop-thumbnailer=enabled
		$(meson_feature ffmpeg ffmpeg-thumbnailer)
		-Dfont-thumbnailer=enabled
		$(meson_feature epub gepub-thumbnailer)
		$(meson_feature gstreamer gst-thumbnailer)
		$(meson_feature jpeg jpeg-thumbnailer)
		$(meson_feature odf odf-thumbnailer)
		-Dpixbuf-thumbnailer=enabled
		$(meson_feature pdf poppler-thumbnailer)
		$(meson_feature raw raw-thumbnailer)
		-Dxdg-cache=enabled
	)
	meson_src_configure
}

pkg_postinst() {
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_icon_cache_update
}
