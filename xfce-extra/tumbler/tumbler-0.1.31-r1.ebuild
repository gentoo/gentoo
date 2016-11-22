# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit xfconf

DESCRIPTION="A thumbnail service for the filemanager of Xfce desktop environment"
HOMEPAGE="http://www.xfce.org/projects/thunar/"
SRC_URI="mirror://xfce/src/apps/${PN}/${PV%.*}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 arm ~ia64 ~ppc ppc64 ~sparc ~x86 ~x86-fbsd ~amd64-linux ~x86-linux"
IUSE="curl debug ffmpeg gstreamer jpeg odf pdf raw"

COMMON_DEPEND=">=dev-libs/dbus-glib-0.100:=
	>=dev-libs/glib-2.24:2=
	media-libs/freetype:2=
	media-libs/libpng:0=
	>=sys-apps/dbus-1.6:=
	>=x11-libs/gdk-pixbuf-2.14:2=
	curl? ( >=net-misc/curl-7.25:= )
	ffmpeg? ( >=media-video/ffmpegthumbnailer-2.0.8:= )
	gstreamer? (
		media-libs/gstreamer:1.0
		media-libs/gst-plugins-base:1.0
		)
	jpeg? ( virtual/jpeg:0= )
	odf? ( >=gnome-extra/libgsf-1.14.20:= )
	pdf? ( >=app-text/poppler-0.12.4[cairo] )
	raw? ( >=media-libs/libopenraw-0.0.8:=[gtk] )"
RDEPEND="${COMMON_DEPEND}
	>=xfce-base/thunar-1.4
	gstreamer? ( media-plugins/gst-plugins-meta:1.0 )"
DEPEND="${COMMON_DEPEND}
	dev-util/gtk-doc-am
	dev-util/intltool
	sys-devel/gettext
	virtual/pkgconfig"

pkg_setup() {
	XFCONF=(
		$(use_enable curl cover-thumbnailer)
		$(use_enable jpeg jpeg-thumbnailer)
		$(use_enable ffmpeg ffmpeg-thumbnailer)
		$(use_enable gstreamer gstreamer-thumbnailer)
		$(use_enable odf odf-thumbnailer)
		$(use_enable pdf poppler-thumbnailer)
		$(use_enable raw raw-thumbnailer)
		$(xfconf_use_debug)
		)

	DOCS=( AUTHORS ChangeLog NEWS README TODO )
}
