# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit xdg meson

DESCRIPTION="Provides GObjects and helper methods to read and write AppStream metadata"
HOMEPAGE="https://people.freedesktop.org/~hughsient/appstream-glib/"
SRC_URI="https://people.freedesktop.org/~hughsient/${PN}/releases/${P}.tar.xz"

LICENSE="LGPL-2.1+"
SLOT="0/8" # soname version
KEYWORDS="~alpha amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="gtk-doc fonts +introspection stemmer"

RDEPEND="
	>=dev-libs/glib-2.58.0:2
	sys-apps/util-linux
	app-arch/libarchive
	>=net-libs/libsoup-2.51.92:2.4
	>=dev-libs/json-glib-1.1.2
	>=x11-libs/gdk-pixbuf-2.31.5:2[introspection?]

	fonts? ( x11-libs/gtk+:3
		>=media-libs/freetype-2.4:2 )
	>=media-libs/fontconfig-2.11:1.0
	dev-libs/libyaml
	stemmer? ( dev-libs/snowball-stemmer )
	x11-libs/pango
	introspection? ( >=dev-libs/gobject-introspection-1.54:= )
"
DEPEND="${RDEPEND}"
# libxml2 required for glib-compile-resources
BDEPEND="
	dev-util/gperf

	dev-libs/libxml2:2
	app-text/docbook-xml-dtd:4.2
	dev-libs/libxslt
	gtk-doc? (
		>=dev-util/gtk-doc-1.9
		app-text/docbook-xml-dtd:4.3
	)
	>=sys-devel/gettext-0.19.8
"
# ${PN} superseeds appdata-tools
RDEPEND="${RDEPEND}
	!<dev-util/appdata-tools-0.1.8-r1
"

src_configure() {
	local emesonargs=(
		-Ddep11=true
		-Dbuilder=true
		-Drpm=false
		-Dalpm=false
		$(meson_use fonts)
		$(meson_use stemmer)
		-Dman=true
		$(meson_use gtk-doc)
		$(meson_use introspection)
	)
	meson_src_configure
}
