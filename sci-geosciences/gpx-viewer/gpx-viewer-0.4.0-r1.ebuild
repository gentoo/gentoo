# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

VALA_MIN_API_VERSION=0.16

inherit autotools-utils gnome2 vala

DESCRIPTION="Simple program to visualize a gpx file"
HOMEPAGE="http://blog.sarine.nl/gpx-viewer/"
SRC_URI="https://edge.launchpad.net/${PN}/trunk/0.4.0/+download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="nls"

RDEPEND="
	dev-libs/gdl:3
	dev-libs/glib:2
	dev-libs/libxml2:2
	>=media-libs/clutter-gtk-1.4.0:1.0
	>=media-libs/libchamplain-0.12.3:0.12[gtk]
	x11-libs/gtk+:3"
DEPEND="${RDEPEND}
	$(vala_depend)
	>=dev-util/intltool-0.21
	virtual/pkgconfig"

PATCHES=( "${FILESDIR}"/${P}-crash-backport )

src_prepare() {
	vala_src_prepare
	autotools-utils_src_prepare
}

src_configure() {
	local myeconfargs=(
		$(use_enable nls)
		--disable-database-updates )
	autotools-utils_src_configure
}

src_compile() {
	autotools-utils_src_compile gpx_viewer_vala.stamp
	autotools-utils_src_compile
}

src_install () {
	autotools-utils_src_install
	dosym ../icons/hicolor/scalable/apps/gpx-viewer.svg /usr/share/pixmaps/gpx-viewer.svg
}
