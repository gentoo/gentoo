# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit xdg-utils

DESCRIPTION="A thumbnail service for Thunar"
HOMEPAGE="
	https://docs.xfce.org/xfce/tumbler/start
	https://gitlab.xfce.org/xfce/tumbler/
"
SRC_URI="https://archive.xfce.org/src/xfce/${PN}/${PV%.*}/${P}.tar.bz2"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~ia64 ~loong ppc ppc64 ~riscv ~sparc x86 ~amd64-linux ~x86-linux"
IUSE="curl epub ffmpeg gstreamer jpeg odf pdf raw"

DEPEND="
	>=dev-libs/glib-2.66.0
	media-libs/freetype:2=
	media-libs/libpng:0=
	>=sys-apps/dbus-1.6
	>=xfce-base/libxfce4util-4.17.1:=
	>=x11-libs/gdk-pixbuf-2.40.0
	curl? ( >=net-misc/curl-7.25:= )
	epub? ( app-text/libgepub )
	ffmpeg? ( >=media-video/ffmpegthumbnailer-2.0.8:= )
	gstreamer? (
		media-libs/gstreamer:1.0
		media-libs/gst-plugins-base:1.0
	)
	jpeg? ( media-libs/libjpeg-turbo:0= )
	odf? ( >=gnome-extra/libgsf-1.14.20:= )
	pdf? ( >=app-text/poppler-0.12.4[cairo] )
	raw? ( >=media-libs/libopenraw-0.0.8:=[gtk] )
"
RDEPEND="
	${DEPEND}
	gstreamer? ( media-plugins/gst-plugins-meta:1.0 )
"
BDEPEND="
	dev-util/gdbus-codegen
	dev-util/glib-utils
	dev-util/gtk-doc-am
	dev-util/intltool
	sys-devel/gettext
	virtual/pkgconfig
"

src_configure() {
	local myconf=(
		$(use_enable curl cover-thumbnailer)
		$(use_enable epub gepub-thumbnailer)
		$(use_enable jpeg jpeg-thumbnailer)
		$(use_enable ffmpeg ffmpeg-thumbnailer)
		$(use_enable gstreamer gstreamer-thumbnailer)
		$(use_enable odf odf-thumbnailer)
		$(use_enable pdf poppler-thumbnailer)
		$(use_enable raw raw-thumbnailer)
	)

	econf "${myconf[@]}"
}

src_install() {
	default
	find "${D}" -name '*.la' -delete || die
}

pkg_postinst() {
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_icon_cache_update
}
