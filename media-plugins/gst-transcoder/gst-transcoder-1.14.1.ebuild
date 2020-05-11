# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit gnome2-utils meson xdg

DESCRIPTION="GStreamer Transcoding API"
HOMEPAGE="https://github.com/pitivi/gst-transcoder"
SRC_URI="https://github.com/pitivi/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2.1+"
SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE="gtk-doc"

RDEPEND="
	dev-libs/gobject-introspection:=
	dev-libs/glib:2
	>=media-libs/gstreamer-${PV}:1.0[introspection]
	>=media-libs/gst-plugins-base-${PV}:1.0[introspection]
"
DEPEND="${RDEPEND}"
BDEPEND="
	gtk-doc? ( dev-util/gtk-doc
		app-text/docbook-xml-dtd:4.1.2 )
	virtual/pkgconfig
"

src_prepare() {
	xdg_src_prepare
	gnome2_environment_reset # fixes gst /dev access under sandbox for g-ir-scanner
}

src_configure() {
	addwrite /dev/dri/
	local emesonargs=(
		$(meson_use !gtk-doc disable_doc)
		# gobject-introspection can be optional now, but the only consumer (pitivi) requires it.
		# Migration to have the option is not done, as gst-transcoder moves into gst-plugins-bad-1.18 anyhow.
		-Ddisable_introspection=false
	)
	meson_src_configure
}
