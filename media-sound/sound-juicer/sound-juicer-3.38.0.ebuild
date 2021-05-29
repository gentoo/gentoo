# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit gnome2 meson

DESCRIPTION="CD ripper for GNOME"
HOMEPAGE="https://wiki.gnome.org/Apps/SoundJuicer"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ia64 ~ppc ~ppc64 ~sparc x86"
IUSE="flac test vorbis"
RESTRICT="!test? ( test )"

DEPEND="
	>=dev-libs/glib-2.49.5:2[dbus]
	>=x11-libs/gtk+-3.21.6:3
	media-libs/libcanberra[gtk3]
	gnome-base/gsettings-desktop-schemas
	>=app-cdr/brasero-2.90
	media-libs/gstreamer:1.0
	media-libs/gst-plugins-base:1.0[vorbis?]
	>=media-libs/musicbrainz-5.0.1:5=
	app-text/iso-codes
	>=media-libs/libdiscid-0.4.0

	sys-apps/dbus

	flac? ( media-plugins/gst-plugins-flac:1.0 )
"
RDEPEND="${DEPEND}
	gnome-base/gvfs[cdda,udev]
	|| (
		media-plugins/gst-plugins-cdparanoia:1.0
		media-plugins/gst-plugins-cdio:1.0
	)
	media-plugins/gst-plugins-meta:1.0
"
BDEPEND="
	dev-libs/appstream-glib
	dev-util/itstool
	>=sys-devel/gettext-0.19.6
	virtual/pkgconfig
	test? ( ~app-text/docbook-xml-dtd-4.3 )
"

src_prepare() {
	# Avoid sandbox failures
	sed -i -e '/gst_inspect/d' meson.build || die
	default
}

src_install() {
	meson_src_install

	# Don't put files in deprecated directory
	rm -rf "${ED}"/usr/doc
}
