# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
USE_RUBY="ruby27 ruby30 ruby31"

RUBY_GNOME2_NEED_VIRTX=yes

inherit ruby-ng-gnome2

DESCRIPTION="Ruby Gtk2 bindings"
KEYWORDS="~amd64 ~ppc ~riscv ~x86"
IUSE=""

DEPEND+=" dev-libs/glib
	x11-libs/cairo
	x11-libs/gdk-pixbuf[introspection]
	x11-libs/gtk+:2[introspection]
	x11-libs/libX11
	x11-libs/pango[introspection]
	x11-themes/hicolor-icon-theme"
RDEPEND+=" dev-libs/glib
	x11-libs/cairo
	x11-libs/gdk-pixbuf[introspection]
	x11-libs/gtk+:2[introspection]
	x11-libs/libX11
	x11-libs/pango[introspection]"

ruby_add_rdepend "
	~dev-ruby/ruby-gdkpixbuf2-${PV}
	~dev-ruby/ruby-atk-${PV}
	~dev-ruby/ruby-pango-${PV}"
