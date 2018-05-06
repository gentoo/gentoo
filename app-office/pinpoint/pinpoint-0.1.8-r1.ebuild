# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit gnome2

DESCRIPTION="A tool for making hackers do excellent presentations"
HOMEPAGE="https://wiki.gnome.org/Apps/Pinpoint"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 x86"
IUSE="+gstreamer +pdf"

# rsvg is used for svg-in-pdf -- clubbing it under pdf for now
RDEPEND="
	>=media-libs/clutter-1.23.7:1.0
	>=media-libs/clutter-gtk-1.6:1.0
	>=dev-libs/glib-2.28:2
	>=x11-libs/cairo-1.9.4
	x11-libs/pango
	x11-libs/gdk-pixbuf:2
	gstreamer? ( media-libs/clutter-gst:3.0 )
	pdf? ( gnome-base/librsvg:2 )
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
"

PATCHES=(
	# Fix CVE-2013-7447, bug #574384, https://bugzilla.gnome.org/show_bug.cgi?id=762029
	"${FILESDIR}"/${P}-CVE-2013-7447.patch
)

src_configure() {
	# dax support is disabled because we don't have it in tree yet and it's
	# experimental
	gnome2_src_configure \
		--disable-dax \
		$(use_enable gstreamer cluttergst) \
		$(use_enable pdf rsvg)
}

src_install() {
	gnome2_src_install

	docompress -x /usr/share/doc/${PF}/examples
	insinto "/usr/share/doc/${PF}/examples"
	doins introduction.pin bg.jpg bowls.jpg linus.jpg
}
