# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit gnome2 vala versionator

DESCRIPTION="Simple document scanning utility"
HOMEPAGE="https://launchpad.net/simple-scan"

MY_PV=$(get_version_component_range 1-2)
SRC_URI="https://launchpad.net/${PN}/${MY_PV}/${PV}/+download/${P}.tar.xz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 ~arm x86"
IUSE="colord"

COMMON_DEPEND="
	>=dev-libs/glib-2.32:2
	dev-libs/libgusb[vala]
	>=media-gfx/sane-backends-1.0.20:=
	>=sys-libs/zlib-1.2.3.1:=
	virtual/jpeg:0=
	x11-libs/cairo:=
	>=x11-libs/gtk+-3:3
	colord? ( >=x11-misc/colord-0.1.24:=[udev] )
"
RDEPEND="${COMMON_DEPEND}
	x11-misc/xdg-utils
	x11-themes/adwaita-icon-theme
"
DEPEND="${COMMON_DEPEND}
	$(vala_depend)
	app-text/yelp-tools
	>=dev-util/intltool-0.35.0
	virtual/pkgconfig
"

src_prepare() {
	# https://bugs.launchpad.net/simple-scan/+bug/1462769
	rm -f src/simple_scan_vala.stamp || die
	vala_src_prepare
	gnome2_src_prepare
}

src_configure() {
	gnome2_src_configure \
		--disable-packagekit \
		$(use_enable colord)
}
