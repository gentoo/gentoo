# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit gnome2 virtualx

DESCRIPTION="Color profile manager for the GNOME desktop"
HOMEPAGE="https://git.gnome.org/browse/gnome-color-manager"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~ia64 ~ppc ~ppc64 ~sparc x86"
IUSE="packagekit raw"

# Need gtk+-3.3.8 for https://bugzilla.gnome.org/show_bug.cgi?id=673331
RDEPEND="
	>=dev-libs/glib-2.31.10:2
	>=media-libs/lcms-2.2:2
	>=media-libs/libcanberra-0.10[gtk3]
	media-libs/libexif
	media-libs/tiff:0=

	>=x11-libs/gtk+-3.3.8:3
	>=x11-libs/vte-0.25.1:2.91
	>=x11-misc/colord-1.3.1:0=
	>=x11-libs/colord-gtk-0.1.20

	packagekit? ( app-admin/packagekit-base )
	raw? ( media-gfx/exiv2 )
"
# docbook-sgml-{utils,dtd:4.1} needed to generate man pages
DEPEND="${RDEPEND}
	app-text/docbook-sgml-dtd:4.1
	app-text/docbook-sgml-utils
	dev-libs/appstream-glib
	dev-libs/libxslt
	>=dev-util/intltool-0.35
	dev-util/itstool
	virtual/pkgconfig
"

src_configure() {
	# Always enable tests since they are check_PROGRAMS anyway
	# appstream does not want to be relax by default !
	gnome2_src_configure \
		--disable-static \
		--enable-tests \
		$(use_enable packagekit) \
		$(use_enable raw exiv)
#		APPSTREAM_UTIL=$(type -P true)
}

src_test() {
	virtx emake check
}

pkg_postinst() {
	gnome2_pkg_postinst

	if ! has_version media-gfx/argyllcms ; then
		elog "If you want to do display or scanner calibration, you will need to"
		elog "install media-gfx/argyllcms"
	fi
}
