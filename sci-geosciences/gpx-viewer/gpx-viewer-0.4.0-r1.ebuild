# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit gnome2 vala

DESCRIPTION="Simple program to visualize a gpx file"
HOMEPAGE="https://github.com/DaveDavenport/gpx-viewer"
SRC_URI="https://edge.launchpad.net/${PN}/trunk/${PV}/+download/${P}.tar.gz"

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
DEPEND="${RDEPEND}"
BDEPEND="
	$(vala_depend)
	>=dev-util/intltool-0.21
	virtual/pkgconfig"

PATCHES=( "${FILESDIR}"/${P}-crash-backport )

src_prepare() {
	default
	vala_src_prepare
}

src_configure() {
	econf \
		$(use_enable nls) \
		--disable-database-updates
}

src_compile() {
	emake gpx_viewer_vala.stamp
	default
}

src_install() {
	default
	dosym ../icons/hicolor/scalable/apps/gpx-viewer.svg /usr/share/pixmaps/gpx-viewer.svg
}
