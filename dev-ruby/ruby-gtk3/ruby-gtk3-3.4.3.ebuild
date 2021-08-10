# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
USE_RUBY="ruby24 ruby25 ruby26 ruby27"

RUBY_GNOME2_NEED_VIRTX=yes

inherit ruby-ng-gnome2

DESCRIPTION="Ruby Gtk3 bindings"
KEYWORDS="amd64 ~ppc ~x86"
IUSE=""

DEPEND+=" dev-libs/glib
	dev-libs/gobject-introspection
	x11-libs/gtk+:3[introspection]"
RDEPEND+=" dev-libs/glib
	dev-libs/gobject-introspection
	x11-libs/gtk+:3[introspection]"

ruby_add_bdepend "~dev-ruby/ruby-glib2-${PV}
	~dev-ruby/ruby-pango-${PV}"

ruby_add_rdepend "
	~dev-ruby/ruby-atk-${PV}
	~dev-ruby/ruby-gdk3-${PV}
	~dev-ruby/ruby-gdkpixbuf2-${PV}
	~dev-ruby/ruby-gio2-${PV}
	~dev-ruby/ruby-pango-${PV}
"
